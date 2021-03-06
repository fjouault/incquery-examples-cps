package org.eclipse.viatra.examples.cps.performance.tests.config.phases

import eu.mondo.sam.core.DataToken
import eu.mondo.sam.core.metrics.TimeMetric
import eu.mondo.sam.core.phases.AtomicPhase
import eu.mondo.sam.core.results.PhaseResult
import org.eclipse.viatra.examples.cps.generator.utils.CPSModelBuilderUtil
import org.eclipse.viatra.examples.cps.performance.tests.config.CPSDataToken

class ClientServerModificationPhase extends AtomicPhase{
	
	extension CPSModelBuilderUtil builderUtil
	
	new(String name) {
		super(name)
		builderUtil = new CPSModelBuilderUtil
	}
	
	override execute(DataToken token, PhaseResult phaseResult) {
		val cpsToken = token as CPSDataToken
		val modifyTimer = new TimeMetric("Modify Time")
		val editTimer = new TimeMetric("Edit Time")
		
//		info("Adding new host instance")
		modifyTimer.startMeasure
		val appType = cpsToken.cps2dep.cps.appTypes.findFirst[it.identifier.contains("Client")]
		val hostInstance = cpsToken.cps2dep.cps.hostTypes.findFirst[it.identifier.contains("client")].instances.head
		
		editTimer.startMeasure
		val index = cpsToken.modificationIndex
		val appID = if (index == 1) "new.app.instance" else "new.app.instance" + index 
		appType.prepareApplicationInstanceWithId(appID, hostInstance)
		editTimer.stopMeasure
		modifyTimer.stopMeasure
		
		phaseResult.addMetrics(editTimer, modifyTimer)
	}
	
}