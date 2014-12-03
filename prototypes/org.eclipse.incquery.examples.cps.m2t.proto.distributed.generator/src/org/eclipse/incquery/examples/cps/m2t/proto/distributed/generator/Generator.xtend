package org.eclipse.incquery.examples.cps.m2t.proto.distributed.generator

import org.eclipse.incquery.examples.cps.deployment.DeploymentApplication
import org.eclipse.incquery.examples.cps.deployment.DeploymentHost
import org.eclipse.incquery.examples.cps.m2t.proto.distributed.generator.api.ICPSGenerator

class Generator  implements ICPSGenerator  {
	
	val String PROJECT_NAME // = "org.eclipse.incquery.examples.cps.m2t.proto.distributed.generated"
	
	new(String projectName){
		PROJECT_NAME = projectName
	}
	
	override generateHostCode(DeploymentHost host) '''
	package «PROJECT_NAME».hosts;

	import org.eclipse.incquery.examples.cps.m2t.proto.distributed.general.applications.Application;
	import org.eclipse.incquery.examples.cps.m2t.proto.distributed.general.communicationlayer.CommunicationNetwork;
	import org.eclipse.incquery.examples.cps.m2t.proto.distributed.general.hosts.BaseHost;
	import org.eclipse.incquery.examples.cps.m2t.proto.distributed.generated.applications.IBMSystemStorageApplication;
	
	import com.google.common.collect.Lists;

	
	public class Host«host.ip» extends BaseHost {
		
		public Host152661025(CommunicationNetwork network) {
			super(network);
			// Add Applications of Host
			applications = Lists.<Application>newArrayList(
					new IBMSystemStorageApplication(this)
			);
		}
	
	} 
	'''
	
	override generateApplicationCode(DeploymentApplication host) {
		throw new UnsupportedOperationException("TODO: auto-generated method stub")
	}
	
	override generateBehaviorCode(DeploymentApplication host) {
		throw new UnsupportedOperationException("TODO: auto-generated method stub")
	}
	
	
	
}