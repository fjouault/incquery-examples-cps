package org.eclipse.viatra.examples.cps.xform.m2t.api

import org.eclipse.viatra.examples.cps.deployment.DeploymentHost
import org.eclipse.viatra.examples.cps.deployment.DeploymentApplication
import org.eclipse.viatra.examples.cps.deployment.Deployment
import org.eclipse.viatra.examples.cps.deployment.DeploymentBehavior
import org.eclipse.viatra.examples.cps.xform.m2t.exceptions.CPSGeneratorException

interface ICPSGenerator {
	def CharSequence generateHostCode(DeploymentHost host) throws CPSGeneratorException
	def CharSequence generateApplicationCode(DeploymentApplication application) throws CPSGeneratorException
	def CharSequence generateBehaviorCode(DeploymentBehavior behavior) throws CPSGeneratorException
	def CharSequence generateDeploymentCode(Deployment deployment) throws CPSGeneratorException
}