# AutoGen — Conversational Multi-Agent Orchestration

AutoGen orchestrates a group of agents that solve a task through a multi-turn
conversation, coordinated by a manager. A `UserProxyAgent` can inject human input
(human-in-the-loop) at any turn. It is provider-agnostic — set `llm_config` to point
at the Anthropic API to run on Claude. See the `claude-api` skill for current model ids.

The `model` strings below are illustrative; replace them with a current Claude model id
(e.g. an Opus / Sonnet / Haiku tier) when running on the Anthropic API.

## AutoGen Pattern

```python
import autogen

# Define agents
user_proxy = autogen.UserProxyAgent(
    name="User",
    human_input_mode="ALWAYS"
)

coder = autogen.AssistantAgent(
    name="Coder",
    llm_config={"model": "gpt-4"},
    system_message="You are an expert programmer"
)

analyst = autogen.AssistantAgent(
    name="Analyst",
    llm_config={"model": "gpt-4"},
    system_message="You are a data analyst"
)

# Create conversation group
group_chat = autogen.GroupChat(
    agents=[user_proxy, coder, analyst],
    messages=[],
    max_round=10
)

# Manager orchestrates
manager = autogen.GroupChatManager(
    groupchat=group_chat,
    llm_config={"model": "gpt-4"}
)

# Start conversation
user_proxy.initiate_chat(
    manager,
    message="Analyze this dataset and write code to visualize it"
)
```

## Driving Claude instead of OpenAI

```python
# AutoGen reads llm_config; point it at the Anthropic API and use a current
# Claude model id (see claude-api skill).
claude_config = {
    "config_list": [{
        "model": "claude-sonnet-4-6",
        "api_type": "anthropic",
        "api_key": "<ANTHROPIC_API_KEY>",
    }]
}

coder = autogen.AssistantAgent(
    name="Coder",
    llm_config=claude_config,
    system_message="You are an expert programmer",
)
```
