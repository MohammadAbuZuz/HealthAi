// testGemini.js
import { GoogleGenerativeAI } from "@google/generative-ai";
import dotenv from "dotenv";
dotenv.config();

const genAI = new GoogleGenerativeAI(process.env.GEMINI_API_KEY);

async function testGemini() {
  try {
    const model = genAI.getGenerativeModel({ model: "gemini-1.5-flash" });
    const result = await model.generateContent("اكتب لي جملة قصيرة للتجربة.");
    console.log("✅ الرد من Gemini:", result.response.text());
  } catch (err) {
    console.error("❌ خطأ في الاتصال بـ Gemini:", err);
  }
}

testGemini();
