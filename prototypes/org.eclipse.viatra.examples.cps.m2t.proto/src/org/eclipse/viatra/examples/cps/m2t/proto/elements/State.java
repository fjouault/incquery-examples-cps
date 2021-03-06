package org.eclipse.viatra.examples.cps.m2t.proto.elements;

import java.util.ArrayList;
import java.util.List;

public class State {
	
	private List<Transition> outgoingTransitions = new ArrayList<Transition>();
	
	private Application application;
	
	public void addOutgoingTransition(Transition t) {
		outgoingTransitions.add(t);
		t.setSourceState(this);
	}
	
	public List<Transition> getOutgoingTransitions() {
		return outgoingTransitions;
	}

	public Application getApplication() {
		return application;
	}

	public void setApplication(Application application) {
		this.application = application;
	}
	
}
