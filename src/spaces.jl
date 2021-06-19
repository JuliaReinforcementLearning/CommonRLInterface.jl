"""
    valid_actions(env)

Return a collection of actions that are appropriate for the current state and player. This should be a subset of actions(env).
"""
function valid_actions end

"""
    valid_action_mask(env)

Return a mask (any `AbstractArray{Bool}`) indicating which actions are valid at the current state and player.

This function only applies to environments with finite action spaces. If both `valid_actions` and `valid_action_mask` are provided, `valid_actions(env)` should return the same set as `actions(env)[valid_action_mask(env)]`.
"""
function valid_action_mask end

"""
    observations(env)

Return a collection of all observations that might be returned by `observe(env)`.

This function is a *static property* of the environment; the value it returns should not change based on the state.
"""
function observations end
