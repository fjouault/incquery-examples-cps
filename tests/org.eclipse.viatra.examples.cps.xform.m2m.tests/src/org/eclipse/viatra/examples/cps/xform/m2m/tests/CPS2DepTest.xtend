package org.eclipse.viatra.examples.cps.xform.m2m.tests

import com.google.common.collect.ImmutableList
import org.eclipse.viatra.examples.cps.tests.PropertiesUtil
import org.eclipse.viatra.examples.cps.xform.m2m.tests.wrappers.BatchIncQuery
import org.eclipse.viatra.examples.cps.xform.m2m.tests.wrappers.BatchOptimized
import org.eclipse.viatra.examples.cps.xform.m2m.tests.wrappers.BatchSimple
import org.eclipse.viatra.examples.cps.xform.m2m.tests.wrappers.BatchViatra
import org.eclipse.viatra.examples.cps.xform.m2m.tests.wrappers.CPSTransformationWrapper
import org.eclipse.viatra.examples.cps.xform.m2m.tests.wrappers.ExplicitTraceability
import org.eclipse.viatra.examples.cps.xform.m2m.tests.wrappers.PartialBatch
import org.eclipse.viatra.examples.cps.xform.m2m.tests.wrappers.QueryResultTraceability
import org.eclipse.viatra.examples.cps.xform.m2m.tests.wrappers.ViatraTransformation
import org.junit.runners.Parameterized.Parameters

class CPS2DepTest extends CPS2DepTestWithoutParameters {

	new(CPSTransformationWrapper wrapper, String wrapperType) {
		super(wrapper, wrapperType)
	}
	
	@Parameters(name = "{index}: {1}")
    public static def transformations() {
        
        /*
         * Do not alter this list other than adding new alternatives
         * or permanently removing them.
         * 
         * Use properties file to disable alternatives!
         */
        val alternatives = ImmutableList.builder
	        .add(new BatchSimple())
			.add(new BatchOptimized())
        	.add(new BatchIncQuery())
        	.add(new QueryResultTraceability())
			.add(new ExplicitTraceability())
			.add(new PartialBatch())
			.add(new ViatraTransformation())
			.add(new BatchViatra())
			.build
		
		val disabled = PropertiesUtil.getDisabledM2MTransformations
		alternatives.filter[!disabled.contains(it.class.simpleName)].map[
			val simpleName = it.class.simpleName
			#[it, simpleName].toArray
		]
    }
    
}
