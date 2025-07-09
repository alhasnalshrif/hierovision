
import { useState } from "react";
import { Button } from "@/components/ui/button";
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";

const KidsMode = () => {
  const [currentGame, setCurrentGame] = useState<string | null>(null);
  const [score, setScore] = useState(0);
  
  const games = [
    {
      id: "matching",
      title: "Hieroglyph Matching",
      icon: "🔤",
      description: "Match hieroglyphs with their meanings!"
    },
    {
      id: "puzzle",
      title: "Pyramid Puzzle",
      icon: "🧩",
      description: "Build your own pyramid piece by piece!"
    },
    {
      id: "story",
      title: "Egyptian Stories",
      icon: "📚",
      description: "Listen to amazing stories about pharaohs and gods!"
    }
  ];

  const hieroglyphPairs = [
    { symbol: "𓊪", meaning: "Sun", matched: false },
    { symbol: "𓇳", meaning: "Bird", matched: false },
    { symbol: "𓈖", meaning: "Water", matched: false },
    { symbol: "𓂀", meaning: "Eye", matched: false }
  ];

  const [gameData, setGameData] = useState(hieroglyphPairs);
  const [selectedSymbol, setSelectedSymbol] = useState<string | null>(null);

  const handleMatch = (meaning: string) => {
    if (selectedSymbol) {
      const symbolData = gameData.find(item => item.symbol === selectedSymbol);
      if (symbolData && symbolData.meaning === meaning) {
        setGameData(prev => prev.map(item => 
          item.symbol === selectedSymbol ? { ...item, matched: true } : item
        ));
        setScore(prev => prev + 10);
        setSelectedSymbol(null);
      } else {
        // Wrong match - provide feedback
        setTimeout(() => setSelectedSymbol(null), 1000);
      }
    }
  };

  return (
    <div className="container mx-auto px-6 py-16">
      {/* Header */}
      <div className="text-center mb-12">
        <div className="text-6xl mb-4">🏺✨</div>
        <h1 className="text-4xl md:text-5xl font-serif font-bold text-[#5E4022] mb-4">
          Kids Egyptian Adventure!
        </h1>
        <p className="text-xl text-[#5E4022]/70 max-w-2xl mx-auto">
          Welcome, young explorer! Let's discover the amazing world of ancient Egypt together!
        </p>
      </div>

      {!currentGame ? (
        // Game Selection
        <div className="grid md:grid-cols-3 gap-8 mb-12">
          {games.map((game) => (
            <Card
              key={game.id}
              className="cursor-pointer bg-gradient-to-br from-[#FFE4B5] to-[#F5E9D3] border-4 border-[#B98E57] hover:border-[#5E4022] transition-all duration-300 hover:scale-105 shadow-xl"
              onClick={() => setCurrentGame(game.id)}
            >
              <CardHeader className="text-center">
                <div className="text-6xl mb-4">{game.icon}</div>
                <CardTitle className="text-2xl font-serif text-[#5E4022]">
                  {game.title}
                </CardTitle>
              </CardHeader>
              <CardContent className="text-center">
                <p className="text-lg text-[#5E4022]/80 font-serif leading-relaxed">
                  {game.description}
                </p>
                <div className="mt-4 flex justify-center space-x-2">
                  <span className="text-2xl">🌟</span>
                  <span className="text-2xl">🏺</span>
                  <span className="text-2xl">🌟</span>
                </div>
              </CardContent>
            </Card>
          ))}
        </div>
      ) : (
        // Game Content
        <div className="max-w-4xl mx-auto">
          {/* Game Header */}
          <div className="flex justify-between items-center mb-8">
            <Button
              onClick={() => setCurrentGame(null)}
              variant="outline"
              className="border-[#B98E57] text-[#5E4022] hover:bg-[#B98E57]/10 font-serif text-lg"
            >
              ← Back to Games
            </Button>
            <div className="text-center">
              <div className="text-3xl text-[#B98E57] mb-2">⭐</div>
              <p className="text-xl font-serif font-bold text-[#5E4022]">Score: {score}</p>
            </div>
          </div>

          {/* Hieroglyph Matching Game */}
          {currentGame === "matching" && (
            <div className="bg-gradient-to-br from-[#F5E9D3] to-[#E3D2B7] rounded-3xl p-8 border-4 border-[#B98E57] shadow-2xl">
              <div className="text-center mb-8">
                <h2 className="text-3xl font-serif font-bold text-[#5E4022] mb-4">
                  Match the Hieroglyphs! 🔤
                </h2>
                <p className="text-lg text-[#5E4022]/70">
                  Click on a hieroglyph, then click on what it means!
                </p>
              </div>

              <div className="grid md:grid-cols-2 gap-8">
                {/* Hieroglyphs */}
                <div>
                  <h3 className="text-2xl font-serif font-bold text-[#5E4022] mb-4 text-center">
                    Hieroglyphs 𓂀
                  </h3>
                  <div className="grid grid-cols-2 gap-4">
                    {gameData.filter(item => !item.matched).map((item) => (
                      <Card
                        key={item.symbol}
                        className={`cursor-pointer text-center p-6 transition-all duration-300 ${
                          selectedSymbol === item.symbol
                            ? "bg-[#B98E57] text-white border-[#5E4022] scale-105"
                            : "bg-white/60 hover:bg-white/80 border-[#B98E57]/30"
                        }`}
                        onClick={() => setSelectedSymbol(item.symbol)}
                      >
                        <div className="text-6xl mb-2">{item.symbol}</div>
                      </Card>
                    ))}
                  </div>
                </div>

                {/* Meanings */}
                <div>
                  <h3 className="text-2xl font-serif font-bold text-[#5E4022] mb-4 text-center">
                    Meanings 📝
                  </h3>
                  <div className="grid grid-cols-2 gap-4">
                    {gameData.filter(item => !item.matched).map((item) => (
                      <Card
                        key={item.meaning}
                        className="cursor-pointer text-center p-6 bg-white/60 hover:bg-white/80 border-[#B98E57]/30 transition-all duration-300 hover:scale-105"
                        onClick={() => handleMatch(item.meaning)}
                      >
                        <div className="text-2xl font-serif text-[#5E4022]">{item.meaning}</div>
                      </Card>
                    ))}
                  </div>
                </div>
              </div>

              {gameData.every(item => item.matched) && (
                <div className="text-center mt-8 p-6 bg-gradient-to-r from-[#FFD700]/20 to-[#B98E57]/20 rounded-2xl border-2 border-[#B98E57]">
                  <div className="text-6xl mb-4">🎉</div>
                  <h3 className="text-3xl font-serif font-bold text-[#5E4022] mb-2">
                    Congratulations!
                  </h3>
                  <p className="text-lg text-[#5E4022]/70">
                    You matched all the hieroglyphs! You're becoming an Egyptian expert!
                  </p>
                </div>
              )}
            </div>
          )}

          {/* Puzzle Game Placeholder */}
          {currentGame === "puzzle" && (
            <div className="bg-gradient-to-br from-[#F5E9D3] to-[#E3D2B7] rounded-3xl p-8 border-4 border-[#B98E57] shadow-2xl text-center">
              <div className="text-8xl mb-6">🏗️</div>
              <h2 className="text-3xl font-serif font-bold text-[#5E4022] mb-4">
                Pyramid Puzzle Coming Soon!
              </h2>
              <p className="text-lg text-[#5E4022]/70">
                Get ready to build amazing pyramids piece by piece!
              </p>
            </div>
          )}

          {/* Story Game Placeholder */}
          {currentGame === "story" && (
            <div className="bg-gradient-to-br from-[#F5E9D3] to-[#E3D2B7] rounded-3xl p-8 border-4 border-[#B98E57] shadow-2xl text-center">
              <div className="text-8xl mb-6">📖</div>
              <h2 className="text-3xl font-serif font-bold text-[#5E4022] mb-4">
                Egyptian Stories Coming Soon!
              </h2>
              <p className="text-lg text-[#5E4022]/70">
                Amazing tales of pharaohs, gods, and ancient adventures await!
              </p>
            </div>
          )}
        </div>
      )}

      {/* Fun Facts Section */}
      <div className="mt-16 bg-white/20 backdrop-blur-sm rounded-2xl p-8 border border-[#B98E57]/20">
        <div className="text-center mb-6">
          <div className="text-4xl text-[#B98E57] mb-2">🤓</div>
          <h3 className="text-2xl font-serif font-bold text-[#5E4022]">
            Fun Egyptian Facts!
          </h3>
        </div>
        <div className="grid md:grid-cols-3 gap-6">
          <div className="text-center p-4 bg-white/30 rounded-xl">
            <div className="text-3xl mb-2">🐱</div>
            <p className="text-[#5E4022] font-serif">
              Ancient Egyptians loved cats so much they worshipped a cat goddess named Bastet!
            </p>
          </div>
          <div className="text-center p-4 bg-white/30 rounded-xl">
            <div className="text-3xl mb-2">🧻</div>
            <p className="text-[#5E4022] font-serif">
              Egyptians invented paper made from papyrus plants that grow by the Nile River!
            </p>
          </div>
          <div className="text-center p-4 bg-white/30 rounded-xl">
            <div className="text-3xl mb-2">⚱️</div>
            <p className="text-[#5E4022] font-serif">
              Mummies were wrapped in hundreds of meters of linen bandages!
            </p>
          </div>
        </div>
      </div>
    </div>
  );
};

export default KidsMode;
