# LangGraph — State-Machine Orchestration

LangGraph models a workflow as a directed graph of nodes (functions that read/write a
shared state dict) connected by edges, including conditional edges for branching and
loops. It is provider-agnostic: swap `ChatOpenAI` for `langchain_anthropic.ChatAnthropic`
to drive Claude. See the `claude-api` skill for current model ids and Anthropic SDK usage.

## LangGraph Basics

```python
from langgraph.graph import Graph
from langchain.llms import ChatOpenAI

graph = Graph()

# Define nodes
def node_plan(state):
    """Planning node."""
    plan = llm.predict("Create plan for: " + state["goal"])
    return {"plan": plan, "goal": state["goal"]}

def node_execute(state):
    """Execution node."""
    result = execute_plan(state["plan"])
    return {"result": result}

def node_review(state):
    """Review node."""
    review = llm.predict(f"Review result: {state['result']}")
    return {"review": review}

# Add nodes
graph.add_node("planner", node_plan)
graph.add_node("executor", node_execute)
graph.add_node("reviewer", node_review)

# Add edges
graph.add_edge("planner", "executor")
graph.add_edge("executor", "reviewer")

# Conditional edge
def should_revise(state):
    return "revise" in state["review"].lower()

graph.add_conditional_edges(
    "reviewer",
    should_revise,
    {True: "planner", False: "end"}
)

graph.add_edge("reviewer", "end")

# Execute
runnable = graph.compile()
result = runnable.invoke({"goal": "Write a report"})
```

## Driving Claude instead of OpenAI

```python
from langchain_anthropic import ChatAnthropic

# Use a current Claude model id (see claude-api skill); e.g. Sonnet for routine
# orchestration nodes, Opus for the hard reasoning step, Haiku for cheap fan-out.
llm = ChatAnthropic(model="claude-sonnet-4-6")
```
