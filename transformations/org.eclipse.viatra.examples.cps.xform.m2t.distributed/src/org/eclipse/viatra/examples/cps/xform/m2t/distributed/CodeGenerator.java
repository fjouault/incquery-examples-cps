package org.eclipse.viatra.examples.cps.xform.m2t.distributed;

import org.eclipse.viatra.examples.cps.deployment.Deployment;
import org.eclipse.viatra.examples.cps.deployment.DeploymentApplication;
import org.eclipse.viatra.examples.cps.deployment.DeploymentBehavior;
import org.eclipse.viatra.examples.cps.deployment.DeploymentHost;
import org.eclipse.viatra.examples.cps.xform.m2t.api.ICPSGenerator;
import org.eclipse.viatra.examples.cps.xform.m2t.exceptions.CPSGeneratorException;
import org.eclipse.viatra.examples.cps.xform.m2t.util.FormatterUtil;
import org.eclipse.viatra.query.runtime.api.ViatraQueryEngine;

public class CodeGenerator implements ICPSGenerator {
    FormatterUtil util = new FormatterUtil();
	private boolean forceCodeFormatting;
	private Generator generator;

	public CodeGenerator(String projectName, ViatraQueryEngine engine, boolean forceCodeFormatting) {
		this.forceCodeFormatting = forceCodeFormatting;
		generator = new Generator(projectName, engine);
	}
	
	@Override
	public CharSequence generateHostCode(DeploymentHost host) throws CPSGeneratorException {
		if(forceCodeFormatting){
			return util.formatCode(generator.generateHostCode(host));
		}
		return generator.generateHostCode(host);
	}

	@Override
	public CharSequence generateApplicationCode(DeploymentApplication application) throws CPSGeneratorException {
		if(forceCodeFormatting){
			return util.formatCode(generator.generateApplicationCode(application));
		}
		return generator.generateApplicationCode(application);
	}

	@Override
	public CharSequence generateBehaviorCode(DeploymentBehavior behavior) throws CPSGeneratorException {
		if(forceCodeFormatting){
			return util.formatCode(generator.generateBehaviorCode(behavior));
		}
		return generator.generateBehaviorCode(behavior);
	}

	@Override
	public CharSequence generateDeploymentCode(Deployment deployment) throws CPSGeneratorException {
		if(forceCodeFormatting){
			return util.formatCode(generator.generateDeploymentCode(deployment));
		}
		return generator.generateDeploymentCode(deployment); 
	}
	 
}
