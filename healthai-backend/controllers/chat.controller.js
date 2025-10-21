// controllers/chat.controller.js
import fetch from "node-fetch";
import dotenv from "dotenv";
dotenv.config();

export const handleChat = async (req, res) => {
  try {
    const { message } = req.body;

    if (!message || message.trim() === "") {
      return res.status(400).json({ error: "Message is required" });
    }

    const apiKey = process.env.GEMINI_API_KEY;

    const response = await fetch(
      `https://generativelanguage.googleapis.com/v1/models/gemini-2.5-flash:generateContent?key=${apiKey}`,
      {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({
          contents: [
            {
              role: "user",
              parts: [{ text: message }],
            },
          ],
        }),
      }
    );

    const data = await response.json();

    if (data.candidates && data.candidates[0]?.content?.parts[0]?.text) {
      const reply = data.candidates[0].content.parts[0].text;
      console.log("✅ Gemini reply:", reply);
      res.json({ reply });
    } else {
      console.error("⚠️ Unexpected response:", data);
      res.status(500).json({ error: "Unexpected Gemini API response" });
    }
  } catch (error) {
    console.error("❌ Gemini API error:", error);
    res.status(500).json({ error: error.message });
  }
};
