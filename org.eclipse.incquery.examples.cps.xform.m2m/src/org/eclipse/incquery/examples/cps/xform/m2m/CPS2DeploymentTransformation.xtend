package org.eclipse.incquery.examples.cps.xform.m2m

import com.google.common.base.Stopwatch
import com.google.common.collect.ImmutableSet
import java.util.concurrent.TimeUnit
import org.apache.log4j.Logger
import org.eclipse.incquery.examples.cps.traceability.CPSToDeployment
import org.eclipse.incquery.examples.cps.xform.m2m.rules.ApplicationRules
import org.eclipse.incquery.examples.cps.xform.m2m.rules.HostRules
import org.eclipse.incquery.runtime.api.IncQueryEngine
import org.eclipse.incquery.runtime.evm.api.ExecutionSchema
import org.eclipse.incquery.runtime.evm.specific.ExecutionSchemas
import org.eclipse.incquery.runtime.evm.specific.Schedulers

import static com.google.common.base.Preconditions.*

class CPS2DeploymentTransformation {
	
	extension Logger logger = Logger.getLogger("cps.xform.CPS2DeploymentTransformation")
//	extension CyberPhysicalSystemFactory cpsFactory = CyberPhysicalSystemFactory.eINSTANCE
//	extension DeploymentFactory depFactory = DeploymentFactory.eINSTANCE
//	extension TraceabilityFactory traceFactory = TraceabilityFactory.eINSTANCE
	extension CpsXformM2M cpsXformM2M = CpsXformM2M.instance
	
	ExecutionSchema schema = null
	
	def execute(CPSToDeployment mapping, IncQueryEngine engine) {
		checkArgument(mapping != null, "Mapping cannot be null!")
		checkArgument(mapping.cps != null, "CPS not defined in mapping!")
		checkArgument(mapping.deployment != null, "Deployment not defined in mapping!")
		checkArgument(engine != null, "Engine cannot be null!")
		
		info('''
			Executing transformation on:
				Cyber-physical system: «mapping.cps.id»''')
		
		info("Preparing queries on engine.")
		val watch = Stopwatch.createStarted
		prepare(engine)
		info('''Prepared queries on engine («watch.elapsed(TimeUnit.MILLISECONDS)» ms)''')
	
		info("Preparing transformation rules.")
		watch.reset.start
		
		val rulesBuilder = ImmutableSet.builder
		rulesBuilder.addAll(HostRules.getRules(engine))
		rulesBuilder.addAll(ApplicationRules.getRules(engine))
		val rules = rulesBuilder.build
		
		val schedulerFactory = Schedulers.getIQEngineSchedulerFactory(engine)
		schema = ExecutionSchemas.createIncQueryExecutionSchema(engine, schedulerFactory)
		schema.logger.level = getEffectiveLevel
		rules.forEach[
			schema.addRule(it)
		]
		
		info('''Prepared transformation rules («watch.elapsed(TimeUnit.MILLISECONDS)» ms)''')
		
		info("Initial execution of transformation rules.")
		watch.reset.start
		schema.startUnscheduledExecution
		info('''Initial execution of transformation rules finished («watch.elapsed(TimeUnit.MILLISECONDS)» ms)''')
	}
	
}