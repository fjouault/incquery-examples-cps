/*******************************************************************************
 * Copyright (c) 2010-2016, Tamas Borbas, IncQuery Labs Ltd.
 * All rights reserved. This program and the accompanying materials
 * are made available under the terms of the Eclipse Public License v1.0
 * which accompanies this distribution, and is available at
 * http://www.eclipse.org/legal/epl-v10.html
 * 
 * Contributors:
 *   Tamas Borbas - initial API and implementation
 *******************************************************************************/
package org.eclipse.viatra.examples.cps.tests;

import org.eclipse.viatra.query.runtime.localsearch.matcher.integration.LocalSearchBackendFactory;
import org.eclipse.viatra.query.runtime.matchers.backend.IQueryBackendFactory;
import org.eclipse.viatra.query.runtime.rete.matcher.ReteBackendFactory;

public enum BackendType {
    Rete, LocalSearch;
    
    public IQueryBackendFactory getNewBackendInstance() {
        switch(this) {
            case Rete: return new ReteBackendFactory();
            case LocalSearch: return LocalSearchBackendFactory.INSTANCE;
            default: return null;
        }
    }
}
