import { useState } from "react";
import { Link, useNavigate } from "react-router-dom";
import { Button } from "@/components/ui/button";
import { useToast } from "@/hooks/use-toast";
import { apiService } from "@/services/api";
import { useAuth } from "@/hooks/useAuth";
import { Loader2 } from "lucide-react";

interface TranslationResult {
  success: boolean;
  original_text: string;
  hieroglyphs: string;
  confidence_score: number;
  transliteration?: string;
  error?: string;
}

const Upload = () => {
  const [englishText, setEnglishText] = useState<string>("");
  const [isTranslating, setIsTranslating] = useState(false);
  const [translationResult, setTranslationResult] = useState<TranslationResult | null>(null);
  const { toast } = useToast();
  const navigate = useNavigate();
  const { user } = useAuth();

  const handleTextChange = (e: React.ChangeEvent<HTMLTextAreaElement>) => {
    setEnglishText(e.target.value);
  };

  const handleTranslate = async () => {
    if (!englishText.trim()) {
      toast({
        title: "No text entered",
        description: "Please enter some English text first.",
        variant: "destructive",
      });
      return;
    }

    setIsTranslating(true);
    try {
      // Call the API to translate English text to hieroglyphs
      const translationResponse = await apiService.translateEnglishToHieroglyphs(englishText) as TranslationResult;

      if (!translationResponse.success) {
        throw new Error(translationResponse.error || 'Translation failed');
      }

      setTranslationResult(translationResponse);

      // Save translation to history if user is authenticated
      if (user) {
        try {
          await apiService.saveTranslation({
            description: `English to Hieroglyphs: "${englishText.substring(0, 50)}${englishText.length > 50 ? '...' : ''}"`,
            translation: translationResponse.hieroglyphs,
            confidence: translationResponse.confidence_score * 100,
            image_path: 'text_translation'
          });

          toast({
            title: "Translation saved!",
            description: "Translation has been added to your history.",
          });
        } catch (saveError) {
          console.warn('Failed to save translation to history:', saveError);
        }
      }

      toast({
        title: "Translation complete!",
        description: "English text has been translated to hieroglyphs.",
      });
    } catch (error: any) {
      console.error('Translation error:', error);
      toast({
        title: "Translation failed",
        description: error.message || "Failed to translate the text. Please try again.",
        variant: "destructive",
      });
    } finally {
      setIsTranslating(false);
    }
  };

  const handleReset = () => {
    setEnglishText("");
    setTranslationResult(null);
  };

  return (
    <div className="container mx-auto px-6 py-16 max-w-4xl">
      {/* Header */}
      <div className="text-center mb-12">
        <div className="text-4xl text-[#B98E57] mb-4">🔤</div>
        <h1 className="text-4xl md:text-5xl font-serif font-bold text-[#5E4022] mb-4">
          Translate English to Hieroglyphs
        </h1>
        <p className="text-lg text-[#5E4022]/70 max-w-2xl mx-auto">
          Enter English text and get instant hieroglyphic translations. Our AI will convert your words into ancient Egyptian symbols.
        </p>
      </div>

      <div className="grid md:grid-cols-2 gap-12 items-start">
        {/* Text Input Area */}
        <div className="space-y-6">
          <div className="relative bg-white/20 backdrop-blur-sm rounded-2xl p-6 border border-[#B98E57]/20 shadow-lg">
            {/* Papyrus scroll decorative corners */}
            <div className="absolute top-2 left-2 text-[#B98E57]/30 text-xl">𓍝</div>
            <div className="absolute top-2 right-2 text-[#B98E57]/30 text-xl">𓍝</div>
            <div className="absolute bottom-2 left-2 text-[#B98E57]/30 text-xl">𓍝</div>
            <div className="absolute bottom-2 right-2 text-[#B98E57]/30 text-xl">𓍝</div>

            <div className="space-y-4">
              <div className="text-center mb-4">
                <div className="text-3xl text-[#B98E57] mb-2">✍️</div>
                <h3 className="text-xl font-serif font-bold text-[#5E4022] mb-2">
                  Enter English Text
                </h3>
                <p className="text-[#5E4022]/60 text-sm">
                  Type or paste your English text for hieroglyphic translation
                </p>
              </div>

              <textarea
                value={englishText}
                onChange={handleTextChange}
                placeholder="Enter your English text here... (e.g., 'pharaoh', 'sun god', 'ancient wisdom')"
                className="w-full h-32 p-4 rounded-xl border border-[#B98E57]/30 bg-[#F5E9D3]/50 text-[#5E4022] placeholder-[#5E4022]/50 font-serif resize-none focus:outline-none focus:ring-2 focus:ring-[#B98E57] focus:border-transparent"
                maxLength={500}
              />

              <div className="text-right text-xs text-[#5E4022]/60">
                {englishText.length}/500 characters
              </div>
            </div>
          </div>

          {/* Action Buttons */}
          <div className="flex gap-4">
            <Button
              onClick={handleTranslate}
              disabled={!englishText.trim() || isTranslating}
              className="flex-1 py-3 bg-gradient-to-r from-[#B98E57] to-[#5E4022] hover:from-[#C69968] hover:to-[#6F4A33] text-white font-serif text-lg shadow-lg hover:shadow-xl transition-all duration-300 disabled:opacity-50 disabled:cursor-not-allowed"
            >
              <span className="flex items-center space-x-2">
                {isTranslating ? (
                  <>
                    <Loader2 className="h-4 w-4 animate-spin" />
                    <span>Translating...</span>
                  </>
                ) : (
                  <>
                    <span>𓂀</span>
                    <span>Translate to Hieroglyphs</span>
                  </>
                )}
              </span>
            </Button>

            <Button
              onClick={handleReset}
              variant="outline"
              disabled={isTranslating}
              className="px-6 border-[#5E4022] text-[#5E4022] hover:bg-[#5E4022]/10 font-serif"
            >
              Reset
            </Button>
          </div>
        </div>

        {/* Results Area */}
        <div className="space-y-6">
          <h3 className="text-2xl font-serif font-bold text-[#5E4022] text-center">
            {translationResult ? "Hieroglyphic Translation" : "Translation Preview"}
          </h3>

          <div className="bg-white/30 backdrop-blur-sm rounded-2xl p-6 border border-[#B98E57]/20 shadow-lg min-h-[300px] flex items-center justify-center">
            {translationResult ? (
              <div className="w-full space-y-4">
                {/* Original Text */}
                <div className="bg-[#F5E9D3]/60 rounded-xl p-4 border border-[#B98E57]/20">
                  <h4 className="font-serif font-bold text-[#5E4022] mb-2 text-center">Original English</h4>
                  <p className="text-[#5E4022] font-serif text-center">
                    "{translationResult.original_text}"
                  </p>
                </div>

                {/* Hieroglyphic Results */}
                <div className="bg-[#F5E9D3]/80 rounded-xl p-4 border border-[#B98E57]/30">
                  <div className="text-center mb-3">
                    <h4 className="font-serif font-bold text-[#5E4022] mb-3">Hieroglyphic Translation</h4>
                    <div className="text-4xl text-[#5E4022] mb-2 font-serif leading-relaxed">
                      {translationResult.hieroglyphs}
                    </div>
                    {translationResult.transliteration && (
                      <div className="text-sm text-[#5E4022]/70 italic">
                        Transliteration: {translationResult.transliteration}
                      </div>
                    )}
                  </div>

                  <div className="flex items-center justify-center mt-3 pt-3 border-t border-[#B98E57]/20">
                    <span className="text-sm text-[#5E4022]/60 mr-2">Confidence:</span>
                    <div className="flex items-center space-x-2">
                      <div className="w-16 h-2 bg-[#5E4022]/20 rounded-full overflow-hidden">
                        <div
                          className="h-full bg-gradient-to-r from-[#B98E57] to-[#5E4022] transition-all duration-500"
                          style={{ width: `${Math.round(translationResult.confidence_score * 100)}%` }}
                        />
                      </div>
                      <span className="text-sm font-bold text-[#5E4022]">
                        {Math.round(translationResult.confidence_score * 100)}%
                      </span>
                    </div>
                  </div>
                </div>

                {/* Action Buttons for Results */}
                <div className="flex gap-2 mt-4">
                  <Link to="/history" className="flex-1">
                    <Button
                      className="w-full bg-[#B98E57] hover:bg-[#C69968] text-white font-serif text-sm"
                      disabled={!user}
                    >
                      📚 View History
                    </Button>
                  </Link>
                  <Button
                    onClick={handleReset}
                    variant="outline"
                    className="flex-1 border-[#5E4022] text-[#5E4022] hover:bg-[#5E4022]/10 font-serif text-sm"
                  >
                    🔄 New Translation
                  </Button>
                </div>

                {!user && (
                  <p className="text-xs text-[#5E4022]/60 text-center mt-2">
                    <Link to="/login" className="underline hover:text-[#5E4022]">Login</Link> to save translations to your history
                  </p>
                )}
              </div>
            ) : englishText.trim() ? (
              <div className="w-full text-center">
                <div className="text-6xl text-[#B98E57]/30 mb-4">𓂀</div>
                <p className="text-[#5E4022]/50 font-serif mb-4">
                  Your English text is ready for translation
                </p>
                <div className="bg-[#F5E9D3]/60 rounded-xl p-4 border border-[#B98E57]/20">
                  <p className="text-[#5E4022] font-serif italic">
                    "{englishText}"
                  </p>
                </div>
              </div>
            ) : (
              <div className="text-center">
                <div className="text-6xl text-[#B98E57]/30 mb-4">𓊪</div>
                <p className="text-[#5E4022]/50 font-serif">
                  Enter English text to see hieroglyphic translation
                </p>
              </div>
            )}
          </div>
        </div>
      </div>

      {/* Tips Section */}
      <div className="mt-16 bg-white/20 backdrop-blur-sm rounded-2xl p-8 border border-[#B98E57]/20">
        <h3 className="text-2xl font-serif font-bold text-[#5E4022] mb-6 text-center">
          Tips for Best Translation Results
        </h3>
        <div className="grid md:grid-cols-3 gap-6">
          <div className="text-center">
            <div className="text-2xl mb-2">📝</div>
            <h4 className="font-serif font-bold text-[#5E4022] mb-2">Simple Words</h4>
            <p className="text-[#5E4022]/70 text-sm">Use common English words for more accurate hieroglyphic translations</p>
          </div>
          <div className="text-center">
            <div className="text-2xl mb-2">🎯</div>
            <h4 className="font-serif font-bold text-[#5E4022] mb-2">Short Phrases</h4>
            <p className="text-[#5E4022]/70 text-sm">Keep sentences brief for clearer hieroglyphic representations</p>
          </div>
          <div className="text-center">
            <div className="text-2xl mb-2">🏛️</div>
            <h4 className="font-serif font-bold text-[#5E4022] mb-2">Ancient Context</h4>
            <p className="text-[#5E4022]/70 text-sm">Focus on concepts familiar to ancient Egyptian culture</p>
          </div>
        </div>
      </div>
    </div>
  );
};

export default Upload;
