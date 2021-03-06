package org.eclipse.viatra.examples.cps.performance.tests

import eu.mondo.sam.core.BenchmarkEngine
import eu.mondo.sam.core.results.JsonSerializer
import eu.mondo.sam.core.scenarios.BenchmarkScenario
import java.util.Random
import org.apache.log4j.Logger
import org.eclipse.viatra.examples.cps.performance.tests.config.CPSDataToken
import org.eclipse.viatra.examples.cps.performance.tests.config.GeneratorType
import org.eclipse.viatra.examples.cps.performance.tests.config.TransformationType
import org.eclipse.viatra.examples.cps.tests.CPSTestBase
import org.eclipse.viatra.examples.cps.xform.m2m.tests.wrappers.CPSTransformationWrapper
import org.junit.After
import org.junit.AfterClass
import org.junit.BeforeClass
import org.junit.Test
import org.junit.runner.RunWith
import org.junit.runners.Parameterized
import org.junit.Before

@RunWith(Parameterized)
abstract class CPSPerformanceTest extends CPSTestBase {
	protected extension CPSTransformationWrapper xform
	protected extension Logger logger = Logger.getLogger("cps.performance.tests.CPSPerformanceTest")
	
	public static val RANDOM_SEED = 11111
	val Random rand = new Random(RANDOM_SEED);
	
	val int scale
	val BenchmarkScenario scenario
	val GeneratorType generatorType
	protected val TransformationType wrapperType
//	IProject project

    
    new(TransformationType wrapperType,	int scale, GeneratorType generatorType, int runIndex) {
		this.wrapperType = wrapperType
		this.scale = scale 
		this.generatorType = generatorType
		this.xform = wrapperType.wrapper
		this.scenario = getScenario(scale, rand)
		this.scenario.runIndex = runIndex
		this.scenario.tool = wrapperType.name + "-" + generatorType.name
    }
    
	def startTest(){
    	info('''START TEST: Xform: «wrapperType», Gen: «generatorType», Scale: «scale», Scenario: «scenario.class.name»''')
    }
    
    def endTest(){
    	info('''END TEST: Xform: «wrapperType», Gen: «generatorType», Scale: «scale», Scenario: «scenario.class.name»''')
    }
	
	@BeforeClass
	static def callGCBefore(){
		callGC
	}
	
	@Before
	def cleanupBefore() {
		callGC
	}

	@After
	def cleanup() {
		val oldWrapper = xform
		oldWrapper.cleanupTransformation;
		callGC
	}

	@AfterClass
	static def callGC(){
		(0..4).forEach[Runtime.getRuntime().gc()]
		
		try{
			Thread.sleep(1000)
		} catch (InterruptedException ex) {
			Logger.getLogger("cps.performance.tests.CPSPerformanceTest").warn("Sleep after System GC interrupted")
		}
	}

	@Test(timeout=600000)
	def void completeToolchainIntegrationTest() {
		val jsonResultFolder="./results/json/"
		completeToolchainIntegrationTest(jsonResultFolder)
	}
	
	def void completeToolchainIntegrationTest(String jsonResultFolder) {
		startTest
		
		// communication unit between the phases
		val CPSDataToken token = new CPSDataToken
		token.scenarioName = scenario.class.simpleName
		token.instancesDirPath = instancesDirPath
		token.seed = RANDOM_SEED
		token.size = scale
		token.xform = xform
		token.generatorType = generatorType
		
		val engine = new BenchmarkEngine
		JsonSerializer::setResultPath(jsonResultFolder)
		
		engine.runBenchmark(scenario, token)

		endTest
	}
	
	def BenchmarkScenario getScenario(int scale, Random rand)
}