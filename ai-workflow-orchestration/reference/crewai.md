# CrewAI — Role-Based Agent Orchestration

CrewAI composes a "crew" of specialized agents (each with a role, goal, and backstory)
and a list of tasks with dependencies. The crew executes tasks, passing context between
agents. It is provider-agnostic — point the agents' LLM config at the Anthropic API to
run on Claude. See the `claude-api` skill for current model ids.

## CrewAI Pattern

```python
from crewai import Agent, Task, Crew

# Define agents with specialized roles
research_agent = Agent(
    role="Research Analyst",
    goal="Gather and analyze information",
    backstory="Expert at finding relevant data"
)

writing_agent = Agent(
    role="Technical Writer",
    goal="Create clear documentation",
    backstory="Writes for technical audiences"
)

# Define tasks
research_task = Task(
    description="Research current AI trends",
    agent=research_agent
)

writing_task = Task(
    description="Write summary of findings",
    agent=writing_agent,
    context=[research_task]  # Depends on research
)

# Create crew
crew = Crew(
    agents=[research_agent, writing_agent],
    tasks=[research_task, writing_task],
    verbose=True
)

# Execute
result = crew.kickoff()
```

## Driving Claude instead of OpenAI

```python
from crewai import LLM

# Use a current Claude model id (see claude-api skill).
claude_llm = LLM(model="anthropic/claude-sonnet-4-6")

research_agent = Agent(
    role="Research Analyst",
    goal="Gather and analyze information",
    backstory="Expert at finding relevant data",
    llm=claude_llm,
)
```
