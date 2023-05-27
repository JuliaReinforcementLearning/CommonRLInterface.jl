var documenterSearchIndex = {"docs":
[{"location":"multiplayer/#Multiplayer-Interface","page":"Multiplayer Interface","title":"Multiplayer Interface","text":"","category":"section"},{"location":"multiplayer/","page":"Multiplayer Interface","title":"Multiplayer Interface","text":"CommonRLInterface provides a basic interface for multiplayer games.","category":"page"},{"location":"multiplayer/#Sequential-games","page":"Multiplayer Interface","title":"Sequential games","text":"","category":"section"},{"location":"multiplayer/","page":"Multiplayer Interface","title":"Multiplayer Interface","text":"Sequential games should implement the optional function players to return a range of player ids, and player to indicate which player's turn it is. There is no requirement that players play in the order returned by the players function. Only the action for the current player should be supplied to act!, but rewards for all players should be returned. observe returns the observation for only the current player.","category":"page"},{"location":"multiplayer/#Simultaneous-Games/Multi-agent-(PO)MDPs","page":"Multiplayer Interface","title":"Simultaneous Games/Multi-agent (PO)MDPs","text":"","category":"section"},{"location":"multiplayer/","page":"Multiplayer Interface","title":"Multiplayer Interface","text":"Environments in which all players take actions at once should implement the all_act! and all_observe optional functions which take a collection of actions for all players and return observations for each player, respectively.","category":"page"},{"location":"multiplayer/#Indicating-reward-properties","page":"Multiplayer Interface","title":"Indicating reward properties","text":"","category":"section"},{"location":"multiplayer/","page":"Multiplayer Interface","title":"Multiplayer Interface","text":"The UtilityStyle trait can be used to indicate that the rewards will meet properties, for example that rewards for all players are identical or that the game is zero-sum.","category":"page"},{"location":"multiplayer/","page":"Multiplayer Interface","title":"Multiplayer Interface","text":"players\nplayer\nall_act!\nall_observe\nUtilityStyle\nZeroSum\nConstantSum\nGeneralSum\nIdenticalUtility","category":"page"},{"location":"multiplayer/#CommonRLInterface.players","page":"Multiplayer Interface","title":"CommonRLInterface.players","text":"players(env::AbstractEnv)\n\nReturn an ordered iterable collection of integer indices for all players, starting with one.\n\nThis function is a static property of the environment; the value it returns should not change based on the state.\n\nExample\n\nplayers(::MyEnv) = 1:2\n\n\n\n\n\n","category":"function"},{"location":"multiplayer/#CommonRLInterface.player","page":"Multiplayer Interface","title":"CommonRLInterface.player","text":"player(env::AbstractEnv)\n\nReturn the index of the player who should play next in the environment.\n\n\n\n\n\n","category":"function"},{"location":"multiplayer/#CommonRLInterface.all_act!","page":"Multiplayer Interface","title":"CommonRLInterface.all_act!","text":"all_act!(env::AbstractEnv, actions::AbstractVector)\n\nTake actions for all players and advance AbstractEnv env forward, and return rewards for all players.\n\nEnvironments that support simultaneous actions by all players should implement this in addition to or instead of act!.\n\n\n\n\n\n","category":"function"},{"location":"multiplayer/#CommonRLInterface.all_observe","page":"Multiplayer Interface","title":"CommonRLInterface.all_observe","text":"all_observe(env::AbstractEnv)\n\nReturn observations from the environment for all players.\n\nEnvironments that support simultaneous actions by all players should implement this in addition to or instead of observe.\n\n\n\n\n\n","category":"function"},{"location":"multiplayer/#CommonRLInterface.UtilityStyle","page":"Multiplayer Interface","title":"CommonRLInterface.UtilityStyle","text":"UtilityStyle(env)\n\nTrait that allows an environment to declare certain properties about the relative utility for the players.\n\nPossible returns are:\n\nZeroSum()\nConstantSum()\nGeneralSum()\nIdenticalUtility()\n\nSee the docstrings for each for more details.\n\n\n\n\n\n","category":"type"},{"location":"multiplayer/#CommonRLInterface.ZeroSum","page":"Multiplayer Interface","title":"CommonRLInterface.ZeroSum","text":"If UtilityStyle(env) == ZeroSum() then the sum of the rewards returned by act! is always zero.\n\n\n\n\n\n","category":"type"},{"location":"multiplayer/#CommonRLInterface.ConstantSum","page":"Multiplayer Interface","title":"CommonRLInterface.ConstantSum","text":"If UtilityStyle(env) == ConstantSum() then the sum of the rewards returned by act! will always be the same constant.\n\n\n\n\n\n","category":"type"},{"location":"multiplayer/#CommonRLInterface.GeneralSum","page":"Multiplayer Interface","title":"CommonRLInterface.GeneralSum","text":"If UtilityStyle(env) == GeneralSum(), the sum of rewards over a trajectory can take any form.\n\n\n\n\n\n","category":"type"},{"location":"multiplayer/#CommonRLInterface.IdenticalUtility","page":"Multiplayer Interface","title":"CommonRLInterface.IdenticalUtility","text":"If UtilityStyle(env) == IdenticalUtility(), all entries of the reward returned by act! will be identical for all players.\n\n\n\n\n\n","category":"type"},{"location":"optional/#Optional-Interface","page":"Optional Interface","title":"Optional Interface","text":"","category":"section"},{"location":"optional/","page":"Optional Interface","title":"Optional Interface","text":"Some environments can provide additional information or behavior beyond what can be expressed with the Required Interface. For this reason, CommonRLInterface has an interface of optional functions.","category":"page"},{"location":"optional/#Determining-what-an-environment-has:-provided","page":"Optional Interface","title":"Determining what an environment has: provided","text":"","category":"section"},{"location":"optional/","page":"Optional Interface","title":"Optional Interface","text":"When other code interacts with an environment, it is common to adjust behavior based on the capabilities that environment provides. The provided function is a programmatic way to determine whether the environment author has implemented certain optional behavior. For instance, an algorithm author might only want to consider the valid subset of actions at the current state if the valid_actions optional function is implemented. This can be accomplished with the following code:","category":"page"},{"location":"optional/","page":"Optional Interface","title":"Optional Interface","text":"if provided(valid_actions, env)\n    acts = valid_actions(env)\nelse\n    acts = actions(env)\nend","category":"page"},{"location":"optional/","page":"Optional Interface","title":"Optional Interface","text":"In most cases, provided can be statically optimized out, so it will have no performance impact.","category":"page"},{"location":"optional/#Optional-Function-List","page":"Optional Interface","title":"Optional Function List","text":"","category":"section"},{"location":"optional/","page":"Optional Interface","title":"Optional Interface","text":"The optional interface currently contains the following functions:","category":"page"},{"location":"optional/","page":"Optional Interface","title":"Optional Interface","text":"clone\nrender\nstate\nsetstate!\nvalid_actions\nvalid_action_mask\nobservations","category":"page"},{"location":"optional/","page":"Optional Interface","title":"Optional Interface","text":"Additional optional functions for multiplayer environments are contained in the Multiplayer Interface","category":"page"},{"location":"optional/","page":"Optional Interface","title":"Optional Interface","text":"To propose adding a new function to the interface, please file an issue with the \"candidate interface function\" label.","category":"page"},{"location":"optional/","page":"Optional Interface","title":"Optional Interface","text":"","category":"page"},{"location":"optional/","page":"Optional Interface","title":"Optional Interface","text":"provided\nclone\nrender\nstate\nsetstate!\nvalid_actions\nvalid_action_mask\nobservations","category":"page"},{"location":"optional/#CommonRLInterface.provided","page":"Optional Interface","title":"CommonRLInterface.provided","text":"provided(f, args...)\n\nTest whether an implementation for f(args...) has been provided.\n\nIf this returns false, you should assume that the environment does not support the function f.\n\nUsage is identical to Base.applicable. The default implementation should be correct for most cases. It should only be implemented by the user in exceptional cases where very fine control is needed.\n\n\n\nprovided(f, types::Type{<:Tuple})\n\nAlternate version of provided with syntax similar to Base.hasmethod.\n\nIf this returns true, it means that the function is provided for any set of arguments with the given types. If it returns false, it may be provided for certain objects. For this reason, algorithm writers should call the provided(f, args...) version when possible.\n\n\n\n\n\n","category":"function"},{"location":"optional/#CommonRLInterface.clone","page":"Optional Interface","title":"CommonRLInterface.clone","text":"clone(env)\n\nCreate a clone of CommonEnv env at the current state.\n\nTwo clones are assumed to be completely independent of each other - no action applied to one will affect the other.\n\n\n\n\n\n","category":"function"},{"location":"optional/#CommonRLInterface.render","page":"Optional Interface","title":"CommonRLInterface.render","text":"render(env)\n\nReturn a showable object that visualizes the environment at the current state.\n\nImplementing this function will facilitate visualization through the Julia Multimedia I/O system, for example, calling display(render(env)) will cause the visualization to pop up in a Jupyter notebook, the Juno plot pane, or an ElectronDisplay.jl window. render should return an object that has Base.show methods for many MIME types. Good examples include a Plots.jl plot, a Compose.jl Context graphic produced by Cairo, or a custom type with show methods.\n\nExample\n\nusing CommonRLInterface\nusing Plots\n\nstruct MyEnv <: AbstractEnv\n    state::Tuple{Int, Int}\nend\n\nCommonRLInterface.render(env::MyEnv) = scatter(env.state[1], env.state[2])\n\n\n\n\n\n","category":"function"},{"location":"optional/#CommonRLInterface.state","page":"Optional Interface","title":"CommonRLInterface.state","text":"state(env::AbstractEnv)\n\nReturn the state of the environment.\n\nSee setstate! for more information about the state.\n\n\n\n\n\n","category":"function"},{"location":"optional/#CommonRLInterface.setstate!","page":"Optional Interface","title":"CommonRLInterface.setstate!","text":"setstate!(env::AbstractEnv, s)\n\nSet the state of the environment to s.\n\nIf two environments have the same state, future outputs (observations and rewards) should be statistically identical given the same sequence of actions.\n\n\n\n\n\n","category":"function"},{"location":"optional/#CommonRLInterface.valid_actions","page":"Optional Interface","title":"CommonRLInterface.valid_actions","text":"valid_actions(env)\n\nReturn a collection of actions that are appropriate for the current state. This should be a subset of actions(env).\n\n\n\n\n\n","category":"function"},{"location":"optional/#CommonRLInterface.valid_action_mask","page":"Optional Interface","title":"CommonRLInterface.valid_action_mask","text":"valid_action_mask(env)\n\nReturn a mask (any AbstractArray{Bool}) indicating which actions are valid.\n\nThis function only applies to environments with finite action spaces. If both valid_actions and valid_action_mask are provided, valid_actions(env) should return the same set as actions(env)[valid_action_mask(env)].\n\n\n\n\n\n","category":"function"},{"location":"optional/#CommonRLInterface.observations","page":"Optional Interface","title":"CommonRLInterface.observations","text":"observations(env)\n\nReturn a collection of all observations that might be returned by observe(env).\n\nThis function is a static property of the environment; the value it returns should not change based on the state.\n\n\n\n\n\n","category":"function"},{"location":"wrappers/#Environment-Wrappers","page":"Environment Wrappers","title":"Environment Wrappers","text":"","category":"section"},{"location":"wrappers/","page":"Environment Wrappers","title":"Environment Wrappers","text":"Wrappers provide a convenient way to alter the behavior of an environment. Wrappers.QuickWrapper provides the simplest way to override the behavior of one or more CommonRLInterface functions. For example,","category":"page"},{"location":"wrappers/","page":"Environment Wrappers","title":"Environment Wrappers","text":"QuickWrapper(env, actions=[-1, 1])","category":"page"},{"location":"wrappers/","page":"Environment Wrappers","title":"Environment Wrappers","text":"will behave just like environment env, except that the action space will only consist of -1 and 1 instead of the original action space of env. The keyword arguments may be functions or static objects.","category":"page"},{"location":"wrappers/","page":"Environment Wrappers","title":"Environment Wrappers","text":"It is also possible to easily create custom wrapper types by subtyping Wrappers.AbstractWrapper.","category":"page"},{"location":"wrappers/","page":"Environment Wrappers","title":"Environment Wrappers","text":"Wrappers.QuickWrapper\nWrappers.AbstractWrapper\nWrappers.wrapped_env\nWrappers.unwrapped","category":"page"},{"location":"wrappers/#CommonRLInterface.Wrappers.QuickWrapper","page":"Environment Wrappers","title":"CommonRLInterface.Wrappers.QuickWrapper","text":"QuickWrapper(env; kwargs...)\n\nCreate a wrapper to override specific behavior of the environment with keywords.\n\nEach keyword argument corresponds to a CommonRLInterface function to be overridden. The keyword arguments can either be static objects or functions. If a keyword argument is a function, the arguments will be the wrapped environment and any other arguments. provided is automatically handled.\n\nExamples\n\nOverride the action space statically:\n\nw = QuickWrapper(env; actions=[-1, 1])\nobserve(w) # returns the observation from env\nactions(w) # returns [-1, 1]\n\nOverride the act! function to return the reward squared:\n\nw = QuickWrapper(env; act! = (env, a) -> act!(env, a).^2)\nact!(w, a) # returns the squared reward for taking action a in env\n\n\n\n\n\n","category":"type"},{"location":"wrappers/#CommonRLInterface.Wrappers.AbstractWrapper","page":"Environment Wrappers","title":"CommonRLInterface.Wrappers.AbstractWrapper","text":"AbstractWrapper\n\nAbstract base class for environment wrappers. For a subtype of AbstractWrapper, all CommonRLInterface functions will be forwarded to the wrapped environment defined by wrapped_env.\n\nInterface functions can be selectively overridden for the new wrapper type. provided and optional functions will be handled correctly by default.\n\nExample\n\nstruct MyActionWrapper{E} <: AbstractWrapper\n    env::E\nend\n    \n# Any subclass of AbstractWrapper MUST implement wrapped_env\nWrappers.wrapped_env(w::MyActionWrapper) = w.env\n\n# Now all CommonRLFunctions functions are forwarded\nw = MyActionWrapper(env)\nobserve(w) # will return an observation from env\nactions(w) # will return the action space from env\n\n# The actions function for the wrapper can be overridden\nCommonRLInterface.actions(w::MyActionWrapper) = [-1, 1]\nactions(w) # will now return [-1, 1]\n\n\n\n\n\n","category":"type"},{"location":"wrappers/#CommonRLInterface.Wrappers.wrapped_env","page":"Environment Wrappers","title":"CommonRLInterface.Wrappers.wrapped_env","text":"wrapped_env(env)\n\nReturn the wrapped environment for an AbstractWrapper.\n\nThis is a required function that must be provided by every AbstractWrapper.\n\nSee also unwrapped.\n\n\n\n\n\n","category":"function"},{"location":"wrappers/#CommonRLInterface.Wrappers.unwrapped","page":"Environment Wrappers","title":"CommonRLInterface.Wrappers.unwrapped","text":"unwrapped(env)\n\nReturn the environment underneath all layers of wrappers.\n\nSee also wrapped_env`.\n\n\n\n\n\n","category":"function"},{"location":"required/#Required-Interface","page":"Required Interface","title":"Required Interface","text":"","category":"section"},{"location":"required/","page":"Required Interface","title":"Required Interface","text":"CommonRLInterface has a basic required interface for all environments consisting of the following functions documented below:","category":"page"},{"location":"required/","page":"Required Interface","title":"Required Interface","text":"reset!\nactions\nobserve\nact!\nterminated","category":"page"},{"location":"required/","page":"Required Interface","title":"Required Interface","text":"reset!\nactions\nobserve\nact!\nterminated","category":"page"},{"location":"required/#CommonRLInterface.reset!","page":"Required Interface","title":"CommonRLInterface.reset!","text":"reset!(env::AbstractEnv)\n\nReset env to its initial state and return nothing.\n\nThis is a required function that must be provided by every AbstractEnv.\n\n\n\n\n\n","category":"function"},{"location":"required/#CommonRLInterface.actions","page":"Required Interface","title":"CommonRLInterface.actions","text":"actions(env::AbstractEnv)\n\nReturn a collection of all of the actions available for AbstractEnv env. If the environment has multiple agents, this function should return the union of all of their actions.\n\nThis is a required function that must be provided by every AbstractEnv.\n\nThis function is a static property of the environment; the value it returns should not change based on the state.\n\n\n\nactions(env::AbstractEnv, player_index)\n\nReturn a collection of all the actions available to a given player.\n\nThis function is a static property of the environment; the value it returns should not change based on the state.\n\n\n\n\n\n","category":"function"},{"location":"required/#CommonRLInterface.observe","page":"Required Interface","title":"CommonRLInterface.observe","text":"observe(env::AbstractEnv)\n\nReturn an observation from the environment for the current player.\n\nThis is a required function that must be provided by every AbstractEnv.\n\n\n\n\n\n","category":"function"},{"location":"required/#CommonRLInterface.act!","page":"Required Interface","title":"CommonRLInterface.act!","text":"r = act!(env::AbstractEnv, a)\n\nTake action a and advance AbstractEnv env forward one step, and return rewards for all players.\n\nThis is a required function that must be provided by every AbstractEnv.\n\nIf the environment has a single player, it is acceptable to return a scalar number. If there are multiple players, it should return a container with all rewards indexed by player number.\n\nExample\n\nSingle Player\n\nfunction act!(env::MyMDPEnv, a)\n    env.state += a + randn()\n    return env.s^2\nend\n\nTwo Player\n\nfunction act!(env::MyMDPEnv, a)\n    env.positions[player(env)] += a   # In this game, each player has a position that is updated by his or her action\n    rewards = in_goal.(env.positions) # Rewards are +1 for being in a goal region, 0 otherwise\n    return rewards                    # returns a vector of rewards for each player\nend\n\n\n\n\n\n","category":"function"},{"location":"required/#CommonRLInterface.terminated","page":"Required Interface","title":"CommonRLInterface.terminated","text":"terminated(env::AbstractEnv)\n\nDetermine whether an environment has finished executing.\n\nIf terminated(env) is true, no further actions should be taken and it is safe to assume that no further rewards will be received.\n\n\n\n\n\n","category":"function"},{"location":"faqs/#Frequently-Asked-Questions","page":"Frequently Asked Questions","title":"Frequently Asked Questions","text":"","category":"section"},{"location":"faqs/#What-does-an-environment-implementation-look-like?","page":"Frequently Asked Questions","title":"What does an environment implementation look like?","text":"","category":"section"},{"location":"faqs/","page":"Frequently Asked Questions","title":"Frequently Asked Questions","text":"A 1-D LQR problem with discrete actions might look like this:","category":"page"},{"location":"faqs/","page":"Frequently Asked Questions","title":"Frequently Asked Questions","text":"mutable struct LQREnv <: AbstractEnv\n    s::Float64\nend\n\nfunction CommonRLInterface.reset!(m::LQREnv)\n    m.s = 0.0\nend\n\nCommonRLInterface.actions(m::LQREnv) = (-1.0, 0.0, 1.0)\nCommonRLInterface.observe(m::LQREnv) = m.s\nCommonRLInterface.terminated(m::LQREnv) = false\n\nfunction CommonRLInterface.act!(m::LQREnv, a)\n    r = -m.s^2 - a^2\n    m.s = m.s + a + randn()\n    return r\nend\n\n# Optional functions can be added like this:\nCommonRLInterface.clone(m::LQREnv) = LQREnv(m.s)","category":"page"},{"location":"faqs/#What-does-a-simulation-with-a-random-policy-look-like?","page":"Frequently Asked Questions","title":"What does a simulation with a random policy look like?","text":"","category":"section"},{"location":"faqs/","page":"Frequently Asked Questions","title":"Frequently Asked Questions","text":"env = YourEnv()\nreset!(env)\nrsum = 0.0\nwhile !terminated(env)\n    rsum += act!(env, rand(actions(env))) \nend\n@show rsum","category":"page"},{"location":"faqs/#What-does-it-mean-for-an-RL-Framework-to-\"support\"-CommonRLInterface?","page":"Frequently Asked Questions","title":"What does it mean for an RL Framework to \"support\" CommonRLInterface?","text":"","category":"section"},{"location":"faqs/","page":"Frequently Asked Questions","title":"Frequently Asked Questions","text":"Suppose you have an abstract environment type in your package called YourEnv. Support for AbstractEnv means:","category":"page"},{"location":"faqs/","page":"Frequently Asked Questions","title":"Frequently Asked Questions","text":"You provide a convert methods  julia  convert(::Type{YourEnv}, ::AbstractEnv)  convert(::Type{AbstractEnv}, ::YourEnv)  If there are additional options in the conversion, you are encouraged to create and document constructors with additional arguments.\nYou provide an implementation of the interface functions from your framework only using functions from CommonRLInterface\nYou implement at minimum the required interface and as many optional functions as you'd like to support, where YourCommonEnv is the concrete type returned by convert(Type{AbstractEnv}, ::YourEnv)","category":"page"},{"location":"faqs/#What-does-it-mean-for-an-algorithm-to-\"support\"-CommonRLInterface?","page":"Frequently Asked Questions","title":"What does it mean for an algorithm to \"support\" CommonRLInterface?","text":"","category":"section"},{"location":"faqs/","page":"Frequently Asked Questions","title":"Frequently Asked Questions","text":"You should have a method of your solver or algorithm that accepts a AbstractEnv, perhaps handling it by converting it to your framework first, e.g.","category":"page"},{"location":"faqs/","page":"Frequently Asked Questions","title":"Frequently Asked Questions","text":"solve(env::AbstractEnv) = solve(convert(YourEnv, env))","category":"page"},{"location":"","page":"Home","title":"Home","text":"CurrentModule = CommonRLInterface","category":"page"},{"location":"#CommonRLInterface","page":"Home","title":"CommonRLInterface","text":"","category":"section"},{"location":"","page":"Home","title":"Home","text":"A description of the purpose of the CommonRLInterface package can be found in the README on GitHub.","category":"page"},{"location":"","page":"Home","title":"Home","text":"Example environments can be found in the examples directory on GitHub.","category":"page"},{"location":"","page":"Home","title":"Home","text":"Detailed reference documentation can be found using the links below:","category":"page"},{"location":"","page":"Home","title":"Home","text":"Pages = [\"required.md\", \"multiplayer.md\", \"optional.md\", \"wrappers.md\", \"faqs.md\"]","category":"page"}]
}
