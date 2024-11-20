from langflow.components.custom_component.custom_component import CustomComponent
from langflow.schema import Data
from playwright.async_api import async_playwright
from typing import Optional, Dict
import asyncio

class AdvancedWebScraper(CustomComponent):
    display_name = "Advanced Web Scraper"
    description = "Modern web scraper with JavaScript support"
    icon = "globe"
    name = "AdvancedWebScraper"

    def build_config(self):
        return {
            "url": {
                "display_name": "URL",
                "type": "str",
                "required": True,
                "placeholder": "https://example.com",
                "info": "The URL to scrape"
            },
            "wait_for_selector": {
                "display_name": "Wait for Element",
                "type": "str",
                "required": False,
                "placeholder": "#main-content",
                "info": "CSS selector to wait for"
            }
        }

    async def scrape_content(self, url: str, wait_for: Optional[str] = None) -> Dict:
        async with async_playwright() as p:
            browser = await p.chromium.launch(
                args=['--no-sandbox', '--disable-dev-shm-usage']
            )
            page = await browser.new_page()
            
            try:
                await page.goto(url, wait_until="networkidle")
                if wait_for:
                    await page.wait_for_selector(wait_for)

                text_content = await page.evaluate("() => document.body.innerText")
                structured_data = await page.evaluate("""
                    () => {
                        return [...document.querySelectorAll('script[type="application/ld+json"]')]
                            .map(el => {
                                try {
                                    return JSON.parse(el.textContent);
                                } catch (e) {
                                    return null;
                                }
                            })
                            .filter(Boolean);
                    }
                """)

            except Exception as e:
                return {"error": str(e), "url": url}
            finally:
                await browser.close()
            
            return {
                "text_content": text_content.strip(),
                "structured_data": structured_data,
                "url": url
            }

    def build(self, url: str, wait_for_selector: str = None) -> Data:
        result = asyncio.run(self.scrape_content(url, wait_for_selector))
        
        return Data(
            content=result,
            type="web_scrape",
            additional_metadata={
                "url": url,
                "has_structured_data": bool(result.get("structured_data"))
            }
        )