package org.eclipse.viatra.examples.cps.performance.tests.config.phases

import eu.mondo.sam.core.DataToken
import eu.mondo.sam.core.phases.AtomicPhase
import eu.mondo.sam.core.results.PhaseResult
import org.eclipse.viatra.examples.cps.generator.utils.CPSModelBuilderUtil
import org.eclipse.viatra.examples.cps.performance.tests.config.CPSDataToken
import eu.mondo.sam.core.metrics.TimeMetric
import eu.mondo.sam.core.metrics.MemoryMetric

class StatisticsBasedModificationPhase extends AtomicPhase{
	
	extension CPSModelBuilderUtil modelBuilder
	
	new(String name) {
		super(name)
		modelBuilder = new CPSModelBuilderUtil
	}
	
	override execute(DataToken token, PhaseResult phaseResult) {
		val cpsToken = token as CPSDataToken
		val modificationTimer = new TimeMetric("Time")
		val modificationMemory = new MemoryMetric("Memory")
		
		modificationTimer.startMeasure
		val appType = cpsToken.cps2dep.cps.appTypes.findFirst[it.identifier.contains("AC_withStateMachine")]
		val hostInstance = cpsToken.cps2dep.cps.hostTypes.findFirst[it.identifier.contains("HC_appContainer")].instances.head
		appType.prepareApplicationInstanceWithId("new.app.instance", hostInstance)
		modificationTimer.stopMeasure
		modificationMemory.measure
		
		phaseResult.addMetrics(modificationTimer, modificationMemory)
	}
	
}