package org.eclipse.viatra.examples.cps.xform.m2m.incr.qrt.util

import org.eclipse.viatra.transformation.evm.specific.resolver.FixedPriorityConflictResolver
import org.eclipse.viatra.transformation.evm.specific.resolver.FixedPriorityConflictSet
import java.util.Map
import org.eclipse.viatra.transformation.evm.api.RuleSpecification
import org.eclipse.viatra.transformation.evm.api.Activation
import org.eclipse.viatra.transformation.evm.specific.crud.CRUDActivationStateEnum

import static com.google.common.base.Preconditions.checkArgument;

class PerJobFixedPriorityConflictResolver extends FixedPriorityConflictResolver {

	override protected createReconfigurableConflictSet() {
		return new PerJobConflictSet(this, priorities)
	}

	static class PerJobConflictSet extends FixedPriorityConflictSet {

		new(FixedPriorityConflictResolver resolver, Map<RuleSpecification<?>, Integer> priorities) {
			super(resolver, priorities)
		}

		override protected getRulePriority(Activation<?> activation) {
			if (CRUDActivationStateEnum.DELETED.equals(activation.state))
				return (-1) * super.getRulePriority(activation)
			return super.getRulePriority(activation)
		}

		override removeActivation(Activation<?> activation) {
			checkArgument(activation != null, "Activation cannot be null!")
			val rulePriority = getRulePriority(activation)
			return priorityBuckets.remove(rulePriority, activation) ||
				priorityBuckets.remove((-1) * rulePriority, activation)
		}

	}
}
