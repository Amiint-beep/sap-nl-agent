import asyncio
import sys

from dotenv import load_dotenv
from pydantic_ai import Agent
from pydantic_ai.mcp import MCPToolset
from fastmcp.client.transports import StdioTransport

load_dotenv()

toolset = MCPToolset(
    StdioTransport(command=".venv\\Scripts\\python.exe", args=["server.py"])
)

agent = Agent("google:gemini-3.6-flash", toolsets=[toolset])


async def main():
    if len(sys.argv) > 1:
        question = " ".join(sys.argv[1:])
    else:
        question = input("Pose ta question : ")

    resultat = await agent.run(question)
    print("\n" + resultat.output)


if __name__ == "__main__":
    asyncio.run(main())