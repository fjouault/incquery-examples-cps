package org.eclipse.incquery.examples.cps.xform.m2m.tests

import org.eclipse.incquery.examples.cps.cyberPhysicalSystem.StateMachine
import org.eclipse.incquery.examples.cps.traceability.CPSToDeployment
import org.junit.Test

import static org.junit.Assert.*
import org.eclipse.incquery.examples.cps.deployment.DeploymentApplication

class StateMachineMappingTest extends CPS2DepTest {
	
	@Test
	def singleStateMachine() {
		val testId = "singleStateMachine"
		info("START TEST: " + testId)
		
		val cps2dep = prepareEmptyModel(testId)
		val hostInstance = cps2dep.prepareHostInstance
		val appInstance = cps2dep.prepareAppInstance(hostInstance)
		val sm = prepareStateMachine(appInstance.type, "simple.cps.sm")
		
		cps2dep.executeTransformation
		
		cps2dep.assertStateMachineMapping(sm)
		
		info("END TEST: " + testId)
	}
	
	def assertStateMachineMapping(CPSToDeployment cps2dep, StateMachine sm) {
		val application = cps2dep.deployment.hosts.head.applications.head
		assertNotNull("State machine not transformed", application.behavior)
		val behavior = application.behavior
		val trace = cps2dep.traces.findFirst[cpsElements.contains(sm)]
		assertNotNull("Trace not created", trace)
		assertEquals("Trace is not complete (cpsElements)", #[sm], trace.cpsElements)
		assertEquals("Trace is not complete (depElements)", #[behavior], trace.deploymentElements)
		assertEquals("ID not copied", sm.id, behavior.description)
	}
	
	@Test
	def stateMachineIncremental() {
		val testId = "stateMachineIncremental"
		info("START TEST: " + testId)
		
		val cps2dep = prepareEmptyModel(testId)
		val hostInstance = cps2dep.prepareHostInstance
		val appInstance = cps2dep.prepareAppInstance(hostInstance)
		cps2dep.executeTransformation
		
		val sm = prepareStateMachine(appInstance.type, "simple.cps.sm")
		
		cps2dep.assertStateMachineMapping(sm)
		
		info("END TEST: " + testId)
	}
	
	@Test
	def removeStateMachine() {
		val testId = "removeStateMachine"
		info("START TEST: " + testId)
		
		val cps2dep = prepareEmptyModel(testId)
		val hostInstance = cps2dep.prepareHostInstance
		val appInstance = cps2dep.prepareAppInstance(hostInstance)
		val sm = prepareStateMachine(appInstance.type, "simple.cps.sm")
		
		cps2dep.executeTransformation
		
		info("Removing state machine from app type.")
		appInstance.type.behavior = null
		
		val application = cps2dep.deployment.hosts.head.applications.head
		assertNull("Behavior not removed from deployment", application.behavior)
		val trace = cps2dep.traces.findFirst[cpsElements.contains(sm)]
		assertNull("Trace not removed", trace)
		
		info("END TEST: " + testId)
	}
	
	@Test
	def changeStateMachineId() {
		val testId = "changeStateMachineId"
		info("START TEST: " + testId)
		
		val cps2dep = prepareEmptyModel(testId)
		val hostInstance = cps2dep.prepareHostInstance
		val appInstance = cps2dep.prepareAppInstance(hostInstance)
		val sm = prepareStateMachine(appInstance.type, "simple.cps.sm")
		
		cps2dep.executeTransformation
		
		info("Changing state machine ID.")
		sm.id = "simple.cps.sm2"
		
		val application = cps2dep.deployment.hosts.head.applications.head
		assertEquals("Id not changed in deployment", sm.id, application.behavior.description)
		
		info("END TEST: " + testId)
	}
	
	@Test
	def addApplicationInstance() {
		val testId = "addApplicationInstance"
		info("START TEST: " + testId)
		
		val cps2dep = prepareEmptyModel(testId)
		val hostInstance = cps2dep.prepareHostInstance
		val appInstance = cps2dep.prepareAppInstance(hostInstance)
		val sm = prepareStateMachine(appInstance.type, "simple.cps.sm")
		
		cps2dep.executeTransformation
		
		createApplicationInstanceWithId(appInstance.type, "simple.cps.app.inst2", hostInstance)
		
		val applications = cps2dep.deployment.hosts.head.applications
		applications.forEach[
			assertNotNull("State machine not created in deployment", it.behavior)
		]
		val traces = cps2dep.traces.filter[cpsElements.contains(sm)]
		assertEquals("Incorrect number of traces created", 1, traces.size)
		assertEquals("Trace is not complete (depElements)", 2, traces.head.deploymentElements.size)
		
		info("END TEST: " + testId)
	}
	
	@Test
	def removeApplicationInstance() {
		val testId = "removeApplicationInstance"
		info("START TEST: " + testId)
		
		val cps2dep = prepareEmptyModel(testId)
		val hostInstance = cps2dep.prepareHostInstance
		val appInstance = cps2dep.prepareAppInstance(hostInstance)
		val sm = prepareStateMachine(appInstance.type, "simple.cps.sm")
		
		cps2dep.executeTransformation
		
		info("Removing instance from type")
		appInstance.type.instances -= appInstance
		
		val traces = cps2dep.traces.filter[cpsElements.contains(sm)]
		assertTrue("Trace not removed", traces.empty)

		info("END TEST: " + testId)
	}
	
	@Test
	def moveStateMachine() {
		val testId = "moveStateMachine"
		info("START TEST: " + testId)
		
		val cps2dep = prepareEmptyModel(testId)
		val hostInstance = cps2dep.prepareHostInstance
		val appInstance = cps2dep.prepareAppInstance(hostInstance)
		val appType2 = cps2dep.createApplicationTypeWithId("simple.cps.app2")
		appType2.createApplicationInstanceWithId("simple.cps.app2.instance", hostInstance)
		
		val sm = prepareStateMachine(appInstance.type, "simple.cps.sm")
		
		cps2dep.executeTransformation
		
		info("Moving state machine")
		appType2.behavior = sm
		
		val traces = cps2dep.traces.filter[cpsElements.contains(sm)]
		assertFalse("Trace for state machine does not exist", traces.empty)
		val depBehavior = traces.head.deploymentElements.head
		val appTraces = cps2dep.traces.filter[deploymentElements.filter(typeof(DeploymentApplication)).exists[behavior == depBehavior]]
		assertFalse("State machine not moved", appTraces.empty)
		
		info("END TEST: " + testId)
	}
	
	@Test
	def moveApplicationInstance() {
		val testId = "moveApplicationInstance"
		info("START TEST: " + testId)
		
		val cps2dep = prepareEmptyModel(testId)
		val hostInstance = cps2dep.prepareHostInstance
		val appInstance = cps2dep.prepareAppInstance(hostInstance)
		val sm = prepareStateMachine(appInstance.type, "simple.cps.sm")
		val appType2 = cps2dep.createApplicationTypeWithId("simple.cps.app2")
		val sm2 = prepareStateMachine(appType2, "simple.cps.sm2")
		
		cps2dep.executeTransformation
		
		info("Moving application instance")
		appInstance.type = appType2
		
		val smTraces = cps2dep.traces.filter[cpsElements.contains(sm)]
		assertTrue("Behavior not moved", smTraces.empty)
		val sm2Traces = cps2dep.traces.filter[cpsElements.contains(sm2)]
		assertFalse("Behavior not moved", sm2Traces.empty)
		val depBehavior = sm2Traces.head.deploymentElements.head
		val appTraces = cps2dep.traces.filter[deploymentElements.filter(typeof(DeploymentApplication)).exists[behavior == depBehavior]]
		assertFalse("Behavior not in app", appTraces.empty)
		
		info("END TEST: " + testId)
	}
	
	@Test
	def deleteHostInstanceOfBehavior() {
		val testId = "deleteHostInstanceOfBehavior"
		info("START TEST: " + testId)
		
		val cps2dep = prepareEmptyModel(testId)
		val hostInstance = cps2dep.prepareHostInstance
		val appInstance = cps2dep.prepareAppInstance(hostInstance)
		val sm = prepareStateMachine(appInstance.type, "simple.cps.sm")
		cps2dep.executeTransformation
		
		info("Deleting host instance")
		cps2dep.cps.hostTypes.head.instances -= hostInstance
		
		val traces = cps2dep.traces.filter[cpsElements.contains(sm)]
		assertTrue("Traces not removed", traces.empty)
		
		info("END TEST: " + testId)
	}
}