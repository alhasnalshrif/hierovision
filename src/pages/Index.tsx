
import { Link } from "react-router-dom";
import { Button } from "@/components/ui/button";

const Index = () => {
  return (
    <div className="container mx-auto px-6 py-16">
      {/* Hero Section */}
      <div className="text-center mb-16">
        <div className="relative mb-8">
          <div className="absolute top-0 left-1/2 transform -translate-x-1/2 -translate-y-4 text-6xl text-[#B98E57]/50">
            𓂀
          </div>
          <h1 className="text-5xl md:text-7xl font-serif font-bold text-[#5E4022] mb-4 pt-12">
            Welcome to HieroVision
          </h1>
          <h2 className="text-2xl md:text-4xl font-serif text-[#B98E57] mb-8">
            Decode the Secrets of Ancient Egypt
          </h2>
        </div>
        
        <p className="text-lg text-[#5E4022]/80 max-w-3xl mx-auto mb-12 leading-relaxed font-serif">
          Embark on a mystical journey through time. Unlock the mysteries of ancient Egyptian hieroglyphs, 
          explore magnificent landmarks, and immerse yourself in the wisdom of the pharaohs with cutting-edge AI technology.
        </p>
      </div>

      {/* Hero Image */}
      <div className="relative mb-16 h-80 md:h-96 rounded-2xl overflow-hidden shadow-2xl mx-auto max-w-5xl">
        <div className="absolute inset-0 bg-gradient-to-r from-[#B98E57]/30 to-[#5E4022]/30 z-10"></div>
        <img 
          src="https://images.unsplash.com/photo-1482881497185-d4a9ddbe4151?auto=format&fit=crop&w=1200&h=600"
          alt="Egyptian pyramids in desert landscape"
          className="w-full h-full object-cover"
        />
        <div className="absolute inset-0 flex items-center justify-center z-20">
          <div className="text-center text-white">
            <div className="text-8xl mb-6">𓉴</div>
            <p className="text-2xl font-serif mb-4">Ancient Wisdom Awaits</p>
            <div className="flex space-x-4 text-3xl">
              <span>𓈖</span>
              <span>𓇳</span>
              <span>𓊨</span>
            </div>
          </div>
        </div>
      </div>

      {/* Main Action Buttons */}
      <div className="grid md:grid-cols-2 lg:grid-cols-4 gap-6 mb-16">
        <Link to="/upload">
          <div className="group bg-gradient-to-br from-[#B98E57] to-[#5E4022] rounded-2xl p-6 text-white hover:scale-105 transition-all duration-300 shadow-lg hover:shadow-2xl text-center h-full">
            <div className="text-4xl mb-4">📜</div>
            <h3 className="text-xl font-serif font-bold mb-2">Translate Hieroglyphs</h3>
            <p className="text-sm opacity-90">Upload images and decode ancient symbols</p>
          </div>
        </Link>
        
        <Link to="/landmarks">
          <div className="group bg-gradient-to-br from-white/30 to-white/10 backdrop-blur-sm border-2 border-[#B98E57]/30 rounded-2xl p-6 text-[#5E4022] hover:scale-105 transition-all duration-300 shadow-lg hover:shadow-2xl text-center h-full">
            <div className="text-4xl mb-4">🏛️</div>
            <h3 className="text-xl font-serif font-bold mb-2">Explore Landmarks</h3>
            <p className="text-sm opacity-80">Discover pyramids, temples, and tombs</p>
          </div>
        </Link>
        
        <Link to="/chat">
          <div className="group bg-gradient-to-br from-white/30 to-white/10 backdrop-blur-sm border-2 border-[#B98E57]/30 rounded-2xl p-6 text-[#5E4022] hover:scale-105 transition-all duration-300 shadow-lg hover:shadow-2xl text-center h-full">
            <div className="text-4xl mb-4">🔮</div>
            <h3 className="text-xl font-serif font-bold mb-2">AnubAI</h3>
            <p className="text-sm opacity-80">Chat with AI about ancient Egypt</p>
          </div>
        </Link>
        
        <Link to="/kids">
          <div className="group bg-gradient-to-br from-white/30 to-white/10 backdrop-blur-sm border-2 border-[#B98E57]/30 rounded-2xl p-6 text-[#5E4022] hover:scale-105 transition-all duration-300 shadow-lg hover:shadow-2xl text-center h-full">
            <div className="text-4xl mb-4">🧒</div>
            <h3 className="text-xl font-serif font-bold mb-2">Kids Adventure</h3>
            <p className="text-sm opacity-80">Fun games and educational content</p>
          </div>
        </Link>
      </div>

      {/* Features Section */}
      <div className="grid md:grid-cols-3 gap-8 mb-16">
        <div className="text-center p-8 rounded-2xl bg-white/20 backdrop-blur-sm border border-[#B98E57]/20 shadow-lg hover:shadow-xl transition-all duration-300">
          <div className="text-5xl mb-6">🔍</div>
          <h3 className="text-2xl font-serif font-bold text-[#5E4022] mb-4">AI-Powered Analysis</h3>
          <p className="text-[#5E4022]/70 leading-relaxed">Advanced machine learning algorithms decode complex hieroglyphic symbols with remarkable accuracy, bringing ancient wisdom to modern understanding.</p>
        </div>
        
        <div className="text-center p-8 rounded-2xl bg-white/20 backdrop-blur-sm border border-[#B98E57]/20 shadow-lg hover:shadow-xl transition-all duration-300">
          <div className="text-5xl mb-6">⚡</div>
          <h3 className="text-2xl font-serif font-bold text-[#5E4022] mb-4">Instant Translation</h3>
          <p className="text-[#5E4022]/70 leading-relaxed">Get immediate translations of your hieroglyph images with detailed explanations, historical context, and cultural significance.</p>
        </div>
        
        <div className="text-center p-8 rounded-2xl bg-white/20 backdrop-blur-sm border border-[#B98E57]/20 shadow-lg hover:shadow-xl transition-all duration-300">
          <div className="text-5xl mb-6">🏺</div>
          <h3 className="text-2xl font-serif font-bold text-[#5E4022] mb-4">Cultural Immersion</h3>
          <p className="text-[#5E4022]/70 leading-relaxed">Explore virtual landmarks, book real tours, and dive deep into the rich tapestry of ancient Egyptian civilization.</p>
        </div>
      </div>

      {/* Quick Access Section */}
      <div className="bg-gradient-to-r from-[#B98E57]/10 to-[#5E4022]/10 rounded-3xl p-8 mb-16 border border-[#B98E57]/20">
        <h2 className="text-3xl font-serif font-bold text-[#5E4022] text-center mb-8">
          Start Your Journey
        </h2>
        <div className="grid md:grid-cols-2 gap-6">
          <Link to="/booking">
            <div className="flex items-center space-x-4 p-6 bg-white/30 rounded-xl hover:bg-white/40 transition-all duration-300 group">
              <div className="text-3xl">🎫</div>
              <div>
                <h3 className="font-serif font-bold text-[#5E4022] group-hover:text-[#B98E57]">Book Egyptian Tours</h3>
                <p className="text-[#5E4022]/70 text-sm">Reserve your spot at iconic landmarks</p>
              </div>
            </div>
          </Link>
          <Link to="/history">
            <div className="flex items-center space-x-4 p-6 bg-white/30 rounded-xl hover:bg-white/40 transition-all duration-300 group">
              <div className="text-3xl">📚</div>
              <div>
                <h3 className="font-serif font-bold text-[#5E4022] group-hover:text-[#B98E57]">View Translation History</h3>
                <p className="text-[#5E4022]/70 text-sm">Track your discoveries and progress</p>
              </div>
            </div>
          </Link>
        </div>
      </div>

      {/* Decorative Egyptian elements */}
      <div className="flex justify-center items-center space-x-8 text-[#B98E57]/40 text-4xl mb-8">
        <span className="animate-pulse">𓈖</span>
        <span className="animate-pulse" style={{animationDelay: '0.5s'}}>𓇳</span>
        <span className="animate-pulse" style={{animationDelay: '1s'}}>𓊨</span>
        <span className="animate-pulse" style={{animationDelay: '1.5s'}}>𓋹</span>
        <span className="animate-pulse" style={{animationDelay: '2s'}}>𓌻</span>
      </div>
    </div>
  );
};

export default Index;
