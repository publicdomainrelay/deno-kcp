package integration

import (
	"testing"
	"time"

	"github.com/johnandersen777/deno-kcp/api/v1alpha1"
)

func TestExampleChainOnRealKCP(t *testing.T) {
	requireLive(t)
	c := startCluster(t)

	c.apply("policyengine.yaml")
	c.expect("the policy engine Running and ready", 180*time.Second, func() bool {
		engine := c.engine(engineName)
		return engine != nil && engine.Status.Phase == v1alpha1.PolicyEngineRunning && engine.Status.Ready
	})
	engine := c.engine(engineName)
	if engine.Status.Endpoint == "" {
		t.Fatal("the policy engine reported no status.endpoint")
	}
	t.Logf("policyengine.yaml: phase=%s ready=%v endpoint=%s", engine.Status.Phase, engine.Status.Ready, engine.Status.Endpoint)

	c.apply("policyworkflowpod.yaml")
	c.expect("the workflow pod Running with an engine endpoint", 120*time.Second, func() bool {
		pod := c.workflowPod(workflowPodName)
		return pod != nil && pod.Status.Phase == v1alpha1.PolicyWorkflowPodRunning && pod.Status.Endpoint != ""
	})
	workflowPod := c.workflowPod(workflowPodName)
	t.Logf("policyworkflowpod.yaml: phase=%s endpoint=%s", workflowPod.Status.Phase, workflowPod.Status.Endpoint)

	c.apply("native-fire-pod.yaml")
	c.expect("the run creator pod Succeeded", 180*time.Second, func() bool {
		pod := c.pod("native-fire-open-policy")
		return pod != nil && terminalPodPhase(pod.Status.Phase)
	})
	fire := c.pod("native-fire-open-policy")
	if fire.Status.Phase != v1alpha1.DenoPodSucceeded {
		t.Fatalf("the run creator pod reached %s, want Succeeded: %s", fire.Status.Phase, fire.Status.Message)
	}
	if fire.Status.Outputs["httpStatus"] != "201" {
		t.Fatalf("the run creator pod outputs = %v, want httpStatus=201", fire.Status.Outputs)
	}
	t.Logf("native-fire-pod.yaml: phase=%s http=%s", fire.Status.Phase, fire.Status.Outputs["httpStatus"])

	var fired *v1alpha1.PolicyWorkflowRun
	c.expect("the created policy run Succeeded", 240*time.Second, func() bool {
		fired = newestRunForPod(c.workflowRuns(), workflowPodName)
		return fired != nil && fired.Status.Phase == v1alpha1.PolicyWorkflowSucceeded
	})
	if fired.Spec.PolicyWorkflowPod != workflowPodName {
		t.Fatalf("the created run pod ref = %q, want %q", fired.Spec.PolicyWorkflowPod, workflowPodName)
	}
	if fired.Status.Outputs["allow"] != "true" {
		t.Fatalf("the created run outputs = %v, want allow=true", fired.Status.Outputs)
	}
	t.Logf("created run: name=%s phase=%s allow=%s", fired.Name, fired.Status.Phase, fired.Status.Outputs["allow"])

	c.apply("runtrigger.yaml")
	var trigger *v1alpha1.RunTrigger
	c.expect("the trigger Triggered with a job name", 180*time.Second, func() bool {
		trigger = c.trigger("on-policy-allow")
		return trigger != nil && trigger.Status.Phase == v1alpha1.RunTriggerTriggered && trigger.Status.JobName != ""
	})
	if trigger.Status.LastRun != fired.Name {
		t.Fatalf("the trigger lastRun = %q, want the created run %q", trigger.Status.LastRun, fired.Name)
	}
	if !trigger.Status.Matched {
		t.Fatalf("the trigger reported matched=%v, want true", trigger.Status.Matched)
	}
	t.Logf("runtrigger.yaml: phase=%s matched=%v lastRun=%s job=%s",
		trigger.Status.Phase, trigger.Status.Matched, trigger.Status.LastRun, trigger.Status.JobName)

	jobName := trigger.Status.JobName
	var job *v1alpha1.DenoJob
	c.expect("the triggered job finished", 300*time.Second, func() bool {
		job = c.job(jobName)
		return job != nil && terminalJobPhase(job.Status.Phase)
	})
	if job.Status.Phase != v1alpha1.DenoJobSucceeded {
		t.Fatalf("the triggered job reached %s, want Succeeded (failed=%d retries=%d)", job.Status.Phase, job.Status.Failed, job.Status.Retries)
	}
	if job.Status.Outputs["allow"] != "true" || job.Status.Outputs["httpStatus"] != "200" {
		t.Fatalf("the triggered job outputs = %v, want allow=true and httpStatus=200", job.Status.Outputs)
	}
	t.Logf("triggered DenoJob: name=%s phase=%s succeeded=%d allow=%s http=%s",
		job.Name, job.Status.Phase, job.Status.Succeeded, job.Status.Outputs["allow"], job.Status.Outputs["httpStatus"])

	denoRun := c.run(job.Status.RunName)
	if denoRun == nil {
		t.Fatalf("the job reports run %q, which cannot be read", job.Status.RunName)
	}
	if denoRun.Status.Phase != v1alpha1.DenoRunSucceeded {
		t.Fatalf("the job's DenoRun reached %s, want Succeeded: %s", denoRun.Status.Phase, denoRun.Status.Message)
	}
	if denoRun.Status.ExitCode == nil || *denoRun.Status.ExitCode != 0 {
		t.Fatalf("the job's DenoRun exit code = %v, want 0", denoRun.Status.ExitCode)
	}
	if denoRun.Status.Outputs["allow"] != "true" || denoRun.Status.Outputs["httpStatus"] != "200" {
		t.Fatalf("the job's DenoRun outputs = %v, want allow=true and httpStatus=200", denoRun.Status.Outputs)
	}
	t.Logf("triggered DenoRun: name=%s phase=%s exit=%d allow=%s http=%s",
		denoRun.Name, denoRun.Status.Phase, *denoRun.Status.ExitCode, denoRun.Status.Outputs["allow"], denoRun.Status.Outputs["httpStatus"])

	t.Logf("chain complete: engine=%s pod=%s created=%s trigger=%s job=%s denoRun=%s",
		engine.Status.Phase, workflowPod.Status.Phase, fired.Name, trigger.Status.Phase, job.Status.Phase, denoRun.Status.Phase)
}

func TestDirectRunAndReadersOnRealKCP(t *testing.T) {
	requireLive(t)
	c := startCluster(t)

	c.apply("policyengine.yaml")
	c.expect("the policy engine Running and ready", 180*time.Second, func() bool {
		engine := c.engine(engineName)
		return engine != nil && engine.Status.Phase == v1alpha1.PolicyEngineRunning && engine.Status.Ready
	})
	engine := c.engine(engineName)
	if engine.Status.Endpoint == "" {
		t.Fatal("the policy engine reported no status.endpoint")
	}

	e, obj := c.load("policy-workflow-run.yaml")
	direct := obj.(*v1alpha1.PolicyWorkflowRun)
	placeholder := direct.Spec.EngineEndpoint
	direct.Spec.EngineEndpoint = engine.Status.Endpoint
	c.create(e, direct)

	var run *v1alpha1.PolicyWorkflowRun
	c.expect("the directly created run Succeeded", 240*time.Second, func() bool {
		observed, err := c.registry.Read(c.ctx, c.ref(directRunName))
		if err != nil {
			return false
		}
		run = observed
		return run.Status.Phase == v1alpha1.PolicyWorkflowSucceeded
	})
	if run.Status.Outputs["allow"] != "true" {
		t.Fatalf("the direct run outputs = %v, want allow=true", run.Status.Outputs)
	}
	if run.Status.ExitStatus != "success" {
		t.Fatalf("the direct run exitStatus = %q, want success", run.Status.ExitStatus)
	}
	t.Logf("policy-workflow-run.yaml: engineEndpoint %s -> %s phase=%s exitStatus=%s allow=%s",
		placeholder, direct.Spec.EngineEndpoint, run.Status.Phase, run.Status.ExitStatus, run.Status.Outputs["allow"])

	c.apply("deno-run.yaml")
	c.expect("deno-run.yaml reached a terminal phase", 180*time.Second, func() bool {
		read := c.run("read-policy-run")
		return read != nil && terminalRunPhase(read.Status.Phase)
	})
	readRun := c.run("read-policy-run")
	if readRun.Status.Phase != v1alpha1.DenoRunSucceeded {
		t.Fatalf("deno-run.yaml reached %s, want Succeeded: %s", readRun.Status.Phase, readRun.Status.Message)
	}
	if readRun.Status.Outputs["httpStatus"] != "200" || readRun.Status.Outputs["allow"] != "true" {
		t.Fatalf("deno-run.yaml outputs = %v, want httpStatus=200 and allow=true", readRun.Status.Outputs)
	}
	t.Logf("deno-run.yaml: phase=%s http=%s allow=%s", readRun.Status.Phase, readRun.Status.Outputs["httpStatus"], readRun.Status.Outputs["allow"])

	c.apply("deno-job.yaml")
	c.expect("deno-job.yaml reached a terminal phase", 240*time.Second, func() bool {
		read := c.job("read-policy-job")
		return read != nil && terminalJobPhase(read.Status.Phase)
	})
	readJob := c.job("read-policy-job")
	if readJob.Status.Phase != v1alpha1.DenoJobSucceeded {
		t.Fatalf("deno-job.yaml reached %s, want Succeeded (failed=%d retries=%d)", readJob.Status.Phase, readJob.Status.Failed, readJob.Status.Retries)
	}
	if readJob.Status.Outputs["httpStatus"] != "200" || readJob.Status.Outputs["allow"] != "true" {
		t.Fatalf("deno-job.yaml outputs = %v, want httpStatus=200 and allow=true", readJob.Status.Outputs)
	}
	t.Logf("deno-job.yaml: phase=%s succeeded=%d http=%s allow=%s",
		readJob.Status.Phase, readJob.Status.Succeeded, readJob.Status.Outputs["httpStatus"], readJob.Status.Outputs["allow"])

	c.apply("deno-pod.yaml")
	c.expect("deno-pod.yaml Running and ready", 180*time.Second, func() bool {
		read := c.pod("read-policy-result")
		return read != nil && read.Status.Phase == v1alpha1.DenoPodRunning && read.Status.Ready && read.Status.RunID != ""
	})
	time.Sleep(5 * time.Second)
	readPod := c.pod("read-policy-result")
	if readPod.Status.Phase != v1alpha1.DenoPodRunning || !readPod.Status.Ready {
		t.Fatalf("deno-pod.yaml left Running+Ready: phase=%s ready=%v message=%s", readPod.Status.Phase, readPod.Status.Ready, readPod.Status.Message)
	}
	if readPod.Status.Restarts != 0 {
		t.Fatalf("deno-pod.yaml restarted %d times, want 0", readPod.Status.Restarts)
	}
	t.Logf("deno-pod.yaml: phase=%s ready=%v restarts=%d runID=%s",
		readPod.Status.Phase, readPod.Status.Ready, readPod.Status.Restarts, readPod.Status.RunID)

	t.Logf("direct path complete: run=%s denoRun=%s denoJob=%s denoPod=%s",
		run.Status.Phase, readRun.Status.Phase, readJob.Status.Phase, readPod.Status.Phase)
}

func newestRunForPod(runs []v1alpha1.PolicyWorkflowRun, podName string) *v1alpha1.PolicyWorkflowRun {
	var newest *v1alpha1.PolicyWorkflowRun
	for i := range runs {
		run := &runs[i]
		if run.Labels[v1alpha1.PolicyWorkflowPodLabel] != podName {
			continue
		}
		if newest == nil || run.CreationTimestamp.After(newest.CreationTimestamp.Time) {
			newest = run
		}
	}
	return newest
}

func terminalPodPhase(phase v1alpha1.DenoPodPhase) bool {
	return phase == v1alpha1.DenoPodSucceeded || phase == v1alpha1.DenoPodFailed
}

func terminalRunPhase(phase v1alpha1.DenoRunPhase) bool {
	return phase == v1alpha1.DenoRunSucceeded || phase == v1alpha1.DenoRunFailed
}

func terminalJobPhase(phase v1alpha1.DenoJobPhase) bool {
	return phase == v1alpha1.DenoJobSucceeded || phase == v1alpha1.DenoJobFailed
}
