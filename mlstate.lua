INITIAL_SCORE = 0

function learn_sarsa(current_state, current_action, reward, next_state, next_action, learning_rate, discount_rate, saved_scores)
	assert(type(current_state) == "table", "Current state for SARSA learning must be a table")
	assert(type(next_state) == "table", "Next state for SARSA learning must be a table")
	assert(type(current_action) == "string", "Current action for SARSA learning must be a string")
	assert(type(next_action) == "string", "Next state for SARSA learning must be a string")

	local current_state_as_str = table.concat(current_state, ",");
	local next_state_as_str = table.concat(next_state, ",");

	local current_score = getSavedScore(saved_scores, current_state_as_str, current_action, INITIAL_SCORE);
	local next_state_score = getSavedScore(saved_scores, next_state_as_str, next_action, INITIAL_SCORE);
	local next_score = current_score + learning_rate * (reward + discount_rate * next_state_score - current_score);

	setSavedScore(saved_scores, current_state_as_str, current_action, INITIAL_SCORE)

	return saved_scores -- not necessary, since tables are pass-by-reference, but could be useful
end

function getSavedScore(saved_scores, state_name, action_name, initial_value)
	if (saved_scores[state_name] == nil or saved_scores[state_name][action_name] == nil) then
		return initial_value
	end
	return saved_scores[state_name][action_name];
end

function setSavedScore(saved_scores, state_name, action_name, value)
	if (saved_scores[state_name] == nil) then
		saved_scores[state_name] = {};
	end
	saved_scores[state_name][action_name] = value;
end

-- used for Q learning, and for picking an action
-- returns action, score as a tuple; returns nil, nil if none is set
function getBestActionAndScoreForState(saved_scores, state_name)
	if (saved_scores[state_name] == nil) then -- no scores saved for that state
		return nil, nil;
	end
	max_action, max_score = nil, nil;
	for action, score in saved_scores[state_name] do
		if (max_score == nil or score > max_score) then
			max_action, max_score = action, score;
		end
	end
	return max_action, max_score;
end