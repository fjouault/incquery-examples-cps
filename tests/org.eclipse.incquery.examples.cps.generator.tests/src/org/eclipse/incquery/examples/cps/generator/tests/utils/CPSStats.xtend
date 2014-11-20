package org.eclipse.incquery.examples.cps.generator.tests.utils

import org.eclipse.incquery.examples.cps.generator.tests.AllocatedAppInstancesMatcher
import org.eclipse.incquery.examples.cps.generator.tests.AppInstancesMatcher
import org.eclipse.incquery.examples.cps.generator.tests.AppTypesMatcher
import org.eclipse.incquery.examples.cps.generator.tests.ConnectedHostsMatcher
import org.eclipse.incquery.examples.cps.generator.tests.HostInstancesMatcher
import org.eclipse.incquery.examples.cps.generator.tests.HostTypesMatcher
import org.eclipse.incquery.examples.cps.generator.tests.StatesMatcher
import org.eclipse.incquery.examples.cps.generator.tests.TransitionsMatcher
import org.eclipse.incquery.runtime.api.IncQueryEngine

class CPSStats {
	
	public int appTypeCount = 0;
	public int appInstanceCount = 0;
	public int hostTypeCount = 0;
	public int hostInstanceCount = 0;
	public int stateCount = 0;
	public int transitionCount = 0;
	public int allocatedAppCount = 0;
	public int connectedHostCount = 0;

	new(IncQueryEngine engine){
		this.appTypeCount = AppTypesMatcher.on(engine).countMatches;
		this.appInstanceCount = AppInstancesMatcher.on(engine).countMatches;
		this.hostTypeCount = HostTypesMatcher.on(engine).countMatches;
		this.hostInstanceCount = HostInstancesMatcher.on(engine).countMatches;
		this.stateCount = StatesMatcher.on(engine).countMatches;
		this.transitionCount = TransitionsMatcher.on(engine).countMatches;
		this.allocatedAppCount = AllocatedAppInstancesMatcher.on(engine).countMatches;
		this.connectedHostCount = ConnectedHostsMatcher.on(engine).countMatches;
	}
}