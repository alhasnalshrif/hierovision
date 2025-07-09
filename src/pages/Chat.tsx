
import { useState } from "react";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Card, CardContent } from "@/components/ui/card";

interface Message {
  id: number;
  text: string;
  isUser: boolean;
  timestamp: Date;
}

const Chat = () => {
  const [messages, setMessages] = useState<Message[]>([
    {
      id: 1,
      text: "Welcome to HieroVision's AnubAI! I am here to share the wisdom of ancient Egypt. Ask me about hieroglyphs, pharaohs, monuments, or any aspect of this magnificent civilization.",
      isUser: false,
      timestamp: new Date()
    }
  ]);
  const [inputMessage, setInputMessage] = useState("");
  const [isTyping, setIsTyping] = useState(false);

  const quickQuestions = [
    "Tell me about the pyramids",
    "Explain hieroglyphs",
    "Who was Cleopatra?",
    "What is the Book of the Dead?",
    "Describe ancient Egyptian gods",
    "How were mummies made?"
  ];

  const callGeminiAPI = async (message: string): Promise<string> => {
    try {
      const GEMINI_API_KEY = import.meta.env.VITE_GEMINI_API_KEY || 'your-gemini-api-key-here';

      const prompt = `You are AnubAI, an AI assistant specializing in ancient Egyptian history and culture. You have deep knowledge of hieroglyphs, pharaohs, monuments, gods, daily life, and all aspects of ancient Egyptian civilization. Respond to the following question about ancient Egypt in an engaging, educational manner. Keep responses informative but accessible. Add appropriate Egyptian hieroglyphic symbols (𓂀, 𓉴, 𓊪𓏏𓇯, etc.) occasionally to enhance the ancient Egyptian theme.

Question: ${message}`;

      const response = await fetch(`https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent`, {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
          'X-goog-api-key': GEMINI_API_KEY,
        },
        body: JSON.stringify({
          contents: [
            {
              parts: [
                {
                  text: prompt
                }
              ]
            }
          ],
          generationConfig: {
            maxOutputTokens: 500,
            temperature: 0.7,
          }
        })
      });

      if (!response.ok) {
        throw new Error(`API request failed: ${response.status}`);
      }

      const data = await response.json();
      return data.candidates[0].content.parts[0].text;
    } catch (error) {
      console.error('Error calling Gemini API:', error);
      return "I apologize, but I'm having trouble accessing the ancient texts right now. Please try asking your question again in a moment. 𓂀";
    }
  };

  const handleSendMessage = async () => {
    if (!inputMessage.trim()) return;

    const userMessage: Message = {
      id: messages.length + 1,
      text: inputMessage,
      isUser: true,
      timestamp: new Date()
    };

    setMessages(prev => [...prev, userMessage]);
    const currentMessage = inputMessage;
    setInputMessage("");
    setIsTyping(true);

    try {
      const aiResponseText = await callGeminiAPI(currentMessage);

      const aiResponse: Message = {
        id: messages.length + 2,
        text: aiResponseText,
        isUser: false,
        timestamp: new Date()
      };

      setMessages(prev => [...prev, aiResponse]);
    } catch (error) {
      console.error('Error generating response:', error);
      const errorResponse: Message = {
        id: messages.length + 2,
        text: "I apologize, but I'm having trouble consulting the ancient texts right now. Please try again in a moment. 𓂀",
        isUser: false,
        timestamp: new Date()
      };
      setMessages(prev => [...prev, errorResponse]);
    } finally {
      setIsTyping(false);
    }
  };

  const handleQuickQuestion = (question: string) => {
    setInputMessage(question);
  };

  return (
    <div className="container mx-auto px-6 py-16 max-w-4xl">
      {/* Header */}
      <div className="text-center mb-12">
        <div className="text-4xl text-[#B98E57] mb-4">🔮</div>
        <h1 className="text-4xl md:text-5xl font-serif font-bold text-[#5E4022] mb-4">
          AnubAI of Ancient Egypt
        </h1>
        <p className="text-lg text-[#5E4022]/70">
          Consult with our AI-powered AnubAI to unlock the secrets and wisdom of ancient Egypt
        </p>
      </div>

      {/* Chat Container */}
      <div className="relative bg-gradient-to-br from-[#F5E9D3] to-[#E3D2B7] rounded-3xl p-8 shadow-2xl border-2 border-[#B98E57]/30 min-h-[600px] flex flex-col">
        {/* Papyrus texture overlay */}
        <div className="absolute inset-0 opacity-5 rounded-3xl bg-gradient-to-r from-transparent via-[#B98E57]/20 to-transparent"></div>

        {/* Decorative corners */}
        <div className="absolute top-4 left-4 text-[#B98E57]/40 text-2xl">𓍝</div>
        <div className="absolute top-4 right-4 text-[#B98E57]/40 text-2xl">𓍝</div>
        <div className="absolute bottom-4 left-4 text-[#B98E57]/40 text-2xl">𓍝</div>
        <div className="absolute bottom-4 right-4 text-[#B98E57]/40 text-2xl">𓍝</div>

        {/* Messages Area */}
        <div className="flex-1 relative z-10 mb-6 space-y-4 overflow-y-auto max-h-96">
          {messages.map((message) => (
            <div
              key={message.id}
              className={`flex ${message.isUser ? 'justify-end' : 'justify-start'}`}
            >
              <Card className={`max-w-xs md:max-w-md ${message.isUser
                  ? 'bg-[#B98E57] text-white border-[#B98E57]'
                  : 'bg-white/60 backdrop-blur-sm border-[#B98E57]/20'
                }`}>
                <CardContent className="p-4">
                  <p className={`text-sm font-serif leading-relaxed ${message.isUser ? 'text-white' : 'text-[#5E4022]'
                    }`}>
                    {message.text}
                  </p>
                  <p className={`text-xs mt-2 ${message.isUser ? 'text-white/70' : 'text-[#5E4022]/50'
                    }`}>
                    {message.timestamp.toLocaleTimeString()}
                  </p>
                </CardContent>
              </Card>
            </div>
          ))}

          {isTyping && (
            <div className="flex justify-start">
              <Card className="bg-white/60 backdrop-blur-sm border-[#B98E57]/20">
                <CardContent className="p-4">
                  <div className="flex items-center space-x-2">
                    <div className="flex space-x-1">
                      <div className="w-2 h-2 bg-[#B98E57] rounded-full animate-bounce"></div>
                      <div className="w-2 h-2 bg-[#B98E57] rounded-full animate-bounce" style={{ animationDelay: '0.1s' }}></div>
                      <div className="w-2 h-2 bg-[#B98E57] rounded-full animate-bounce" style={{ animationDelay: '0.2s' }}></div>
                    </div>
                    <span className="text-[#5E4022]/70 text-sm font-serif">AnubAI is consulting the ancient texts...</span>
                  </div>
                </CardContent>
              </Card>
            </div>
          )}
        </div>

        {/* Quick Questions */}
        <div className="relative z-10 mb-6">
          <h3 className="text-lg font-serif font-bold text-[#5E4022] mb-3 text-center">
            Quick Questions
          </h3>
          <div className="grid grid-cols-2 md:grid-cols-3 gap-2">
            {quickQuestions.map((question, index) => (
              <Button
                key={index}
                variant="outline"
                size="sm"
                onClick={() => handleQuickQuestion(question)}
                className="border-[#B98E57]/50 text-[#5E4022] hover:bg-[#B98E57]/10 font-serif text-xs"
              >
                {question}
              </Button>
            ))}
          </div>
        </div>

        {/* Input Area */}
        <div className="relative z-10 flex gap-2">
          <Input
            placeholder="Ask the AnubAI about ancient Egypt..."
            value={inputMessage}
            onChange={(e) => setInputMessage(e.target.value)}
            onKeyPress={(e) => e.key === 'Enter' && handleSendMessage()}
            className="flex-1 bg-white/50 border-[#B98E57]/30 focus:border-[#B98E57] font-serif"
          />
          <Button
            onClick={handleSendMessage}
            disabled={!inputMessage.trim() || isTyping}
            className="bg-gradient-to-r from-[#B98E57] to-[#5E4022] text-white font-serif px-6"
          >
            <span className="flex items-center space-x-2">
              <span>Send</span>
              <span>𓂀</span>
            </span>
          </Button>
        </div>
      </div>
    </div>
  );
};

export default Chat;
