import asyncio
from dotenv import load_dotenv
from pydantic_ai import Agent
from pydantic_ai.mcp import MCPToolset
from fastmcp.client.transports import StdioTransport

load_dotenv()

# on lance le serveur mcp en arriere plan puis l'agent y accède en donnant le chemin et le noom du server
toolset = MCPToolset(
    StdioTransport(command=".venv\\Scripts\\python.exe", args=["server.py"])
)

# L'agent : modèle llm  + outils du serveur MCP
agent = Agent("google:gemini-flash-latest", toolsets=[toolset])


async def main():
    question = input("Pose ta question : ")
    resultat = await agent.run(question)
    print("\n" + resultat.output)


if __name__ == "__main__":
    asyncio.run(main())