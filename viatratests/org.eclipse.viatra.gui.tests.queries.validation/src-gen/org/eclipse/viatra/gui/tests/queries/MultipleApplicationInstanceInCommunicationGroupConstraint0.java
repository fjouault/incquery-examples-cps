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
package org.eclipse.viatra.gui.tests.queries;

import java.util.List;
import java.util.Map;
import java.util.Set;
import com.google.common.collect.ImmutableList;
import com.google.common.collect.ImmutableMap;
import com.google.common.collect.ImmutableSet;

import org.eclipse.viatra.addon.validation.core.api.Severity;
import org.eclipse.viatra.addon.validation.core.api.IConstraintSpecification;
import org.eclipse.viatra.query.runtime.api.IPatternMatch;
import org.eclipse.viatra.query.runtime.api.IQuerySpecification;
import org.eclipse.viatra.query.runtime.api.ViatraQueryMatcher;
import org.eclipse.viatra.query.runtime.exception.ViatraQueryException;

import org.eclipse.viatra.gui.tests.queries.util.MultipleApplicationInstanceInCommunicationGroupQuerySpecification;

public class MultipleApplicationInstanceInCommunicationGroupConstraint0 implements IConstraintSpecification {

    private MultipleApplicationInstanceInCommunicationGroupQuerySpecification querySpecification;

    public MultipleApplicationInstanceInCommunicationGroupConstraint0() throws ViatraQueryException {
        querySpecification = MultipleApplicationInstanceInCommunicationGroupQuerySpecification.instance();
    }

    @Override
    public String getMessageFormat() {
        return "Multiple instances of $app.identifier$ are reachable from $sourceHostInstance.identifier$";
    }


    @Override
    public Map<String,Object> getKeyObjects(IPatternMatch signature) {
        Map<String,Object> map = ImmutableMap.of(
            "sourceHostInstance",signature.get("sourceHostInstance")
        );
        return map;
    }

    @Override
    public List<String> getKeyNames() {
        List<String> keyNames = ImmutableList.of(
            "sourceHostInstance"
        );
        return keyNames;
    }

    @Override
    public List<String> getPropertyNames() {
        List<String> propertyNames = ImmutableList.of(
            "app"
        );
        return propertyNames;
    }

    @Override
    public Set<List<String>> getSymmetricPropertyNames() {
        Set<List<String>> symmetricPropertyNamesSet = ImmutableSet.<List<String>>of(
        );
        return symmetricPropertyNamesSet;
    }

    @Override
    public Set<List<String>> getSymmetricKeyNames() {
        Set<List<String>> symmetricKeyNamesSet = ImmutableSet.<List<String>>of(
        );
        return symmetricKeyNamesSet;
    }

    @Override
    public Severity getSeverity() {
        return Severity.ERROR;
    }

    @Override
    public IQuerySpecification<? extends ViatraQueryMatcher<? extends IPatternMatch>> getQuerySpecification() {
        return querySpecification;
    }

}
