from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from langflow import CustomComponent
from components.tools.advanced_scraper import AdvancedWebScraper

app = FastAPI()

app.add_middleware(
    CORSMiddleware,
    allow_origins=["http://localhost:3000"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Register custom components with LangFlow
CustomComponent.register_custom_component(AdvancedWebScraper)

@app.get("/")
async def root():
    return {"message": "FastAPI Backend is running"}
