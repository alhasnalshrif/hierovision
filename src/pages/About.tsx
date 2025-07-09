
import { Button } from "@/components/ui/button";
import { Link } from "react-router-dom";

const About = () => {
  const timelineSteps = [
    {
      icon: "📱",
      title: "Upload Your Image",
      description: "Simply upload a photo containing Egyptian hieroglyphs from your device"
    },
    {
      icon: "🤖",
      title: "AI Analysis",
      description: "Our advanced AI analyzes the symbols using machine learning trained on thousands of hieroglyphic texts"
    },
    {
      icon: "🔍",
      title: "Symbol Recognition",
      description: "Each hieroglyph is identified and matched against our comprehensive database"
    },
    {
      icon: "📜",
      title: "Translation & Context",
      description: "Receive accurate translations with historical context and cultural significance"
    },
    {
      icon: "💾",
      title: "Save & Share",
      description: "Save your discoveries to your history and share them with the community"
    }
  ];

  return (
    <div className="container mx-auto px-6 py-16 max-w-4xl">
      {/* Header */}
      <div className="text-center mb-16">
        <div className="text-4xl text-[#B98E57] mb-4">ℹ️</div>
        <h1 className="text-4xl md:text-5xl font-serif font-bold text-[#5E4022] mb-6">
          How AI Brings Ancient Egypt Back to Life
        </h1>
        <p className="text-lg text-[#5E4022]/80 max-w-2xl mx-auto leading-relaxed">
          Discover how cutting-edge artificial intelligence transforms the study of ancient Egyptian
          hieroglyphs, making the wisdom of the pharaohs accessible to everyone.
        </p>
      </div>

      {/* Hero Story Section */}
      <div className="bg-white/30 backdrop-blur-sm rounded-2xl p-8 mb-16 border border-[#B98E57]/20 shadow-lg">
        <div className="text-center mb-8">
          <div className="text-3xl text-[#B98E57] mb-4">🏺</div>
          <h2 className="text-2xl font-serif font-bold text-[#5E4022] mb-4">
            Bridging 4,000 Years of History
          </h2>
        </div>

        <div className="grid md:grid-cols-2 gap-8 items-center">
          <div>
            <p className="text-[#5E4022]/80 leading-relaxed mb-4">
              For millennia, the secrets of ancient Egypt remained locked within stone walls and papyrus scrolls.
              Hieroglyphs—the sacred writing of the pharaohs—told stories of gods, kings, and daily life along the Nile.
            </p>
            <p className="text-[#5E4022]/80 leading-relaxed">
              Today, HieroVision harnesses the power of artificial intelligence to decode these ancient messages
              instantly, bringing the voices of the past into our modern world.
            </p>
          </div>
          <div className="text-center">
            <div className="bg-[#F5E9D3]/50 rounded-xl p-6 border border-[#B98E57]/20">
              <div className="text-4xl text-[#5E4022] mb-4 leading-relaxed">
                𓊪 𓇳 𓏺<br />
                𓈖 𓂋 𓏏
              </div>
              <p className="text-sm text-[#5E4022]/60 font-serif italic">
                "May you live like Ra forever"
              </p>
            </div>
          </div>
        </div>
      </div>

      {/* How It Works Timeline */}
      <div className="mb-16">
        <div className="text-center mb-12">
          <h2 className="text-3xl font-serif font-bold text-[#5E4022] mb-4">
            How HieroVision Works
          </h2>
          <p className="text-[#5E4022]/70 max-w-2xl mx-auto">
            Our revolutionary process combines ancient wisdom with modern technology
          </p>
        </div>

        <div className="space-y-8">
          {timelineSteps.map((step, index) => (
            <div key={index} className="relative">
              {/* Timeline line */}
              {index < timelineSteps.length - 1 && (
                <div className="absolute left-8 top-16 w-0.5 h-16 bg-gradient-to-b from-[#B98E57] to-[#B98E57]/30"></div>
              )}

              <div className="flex items-start space-x-6">
                {/* Icon circle */}
                <div className="w-16 h-16 bg-gradient-to-br from-[#B98E57] to-[#5E4022] rounded-full flex items-center justify-center text-white text-2xl shadow-lg flex-shrink-0">
                  {step.icon}
                </div>

                {/* Content */}
                <div className="bg-white/30 backdrop-blur-sm rounded-xl p-6 flex-1 border border-[#B98E57]/20 shadow-md">
                  <div className="flex items-center space-x-3 mb-3">
                    <div className="w-8 h-8 bg-[#B98E57] text-white rounded-full flex items-center justify-center text-sm font-bold">
                      {index + 1}
                    </div>
                    <h3 className="text-xl font-serif font-bold text-[#5E4022]">
                      {step.title}
                    </h3>
                  </div>
                  <p className="text-[#5E4022]/80 leading-relaxed">
                    {step.description}
                  </p>
                </div>
              </div>
            </div>
          ))}
        </div>
      </div>

      {/* Technology Section */}
      <div className="bg-white/30 backdrop-blur-sm rounded-2xl p-8 mb-16 border border-[#B98E57]/20">
        <div className="text-center mb-8">
          <div className="text-3xl text-[#B98E57] mb-4">🧠</div>
          <h2 className="text-2xl font-serif font-bold text-[#5E4022] mb-4">
            The Science Behind the Magic
          </h2>
        </div>

        <div className="grid md:grid-cols-3 gap-6">
          <div className="text-center p-4">
            <div className="text-2xl mb-3">🔬</div>
            <h3 className="font-serif font-bold text-[#5E4022] mb-2">Machine Learning</h3>
            <p className="text-[#5E4022]/70 text-sm">
              Trained on thousands of authenticated hieroglyphic texts and inscriptions
            </p>
          </div>
          <div className="text-center p-4">
            <div className="text-2xl mb-3">👁️</div>
            <h3 className="font-serif font-bold text-[#5E4022] mb-2">Computer Vision</h3>
            <p className="text-[#5E4022]/70 text-sm">
              Advanced image recognition identifies symbols regardless of age or condition
            </p>
          </div>
          <div className="text-center p-4">
            <div className="text-2xl mb-3">📚</div>
            <h3 className="font-serif font-bold text-[#5E4022] mb-2">Linguistic Database</h3>
            <p className="text-[#5E4022]/70 text-sm">
              Comprehensive library of hieroglyphic meanings and historical contexts
            </p>
          </div>
        </div>
      </div>

      {/* Features Grid */}
      <div className="grid md:grid-cols-2 gap-8 mb-16">
        <div className="bg-white/30 backdrop-blur-sm rounded-xl p-6 border border-[#B98E57]/20">
          <div className="text-2xl text-[#B98E57] mb-3">🎯</div>
          <h3 className="text-xl font-serif font-bold text-[#5E4022] mb-3">Accuracy You Can Trust</h3>
          <p className="text-[#5E4022]/80 text-sm leading-relaxed">
            Our AI achieves over 90% accuracy on clear hieroglyphic texts, continuously improving
            through machine learning and expert validation.
          </p>
        </div>

        <div className="bg-white/30 backdrop-blur-sm rounded-xl p-6 border border-[#B98E57]/20">
          <div className="text-2xl text-[#B98E57] mb-3">⚡</div>
          <h3 className="text-xl font-serif font-bold text-[#5E4022] mb-3">Instant Results</h3>
          <p className="text-[#5E4022]/80 text-sm leading-relaxed">
            What once took scholars months to decipher now happens in seconds, making
            ancient wisdom accessible to curious minds worldwide.
          </p>
        </div>

        <div className="bg-white/30 backdrop-blur-sm rounded-xl p-6 border border-[#B98E57]/20">
          <div className="text-2xl text-[#B98E57] mb-3">🌍</div>
          <h3 className="text-xl font-serif font-bold text-[#5E4022] mb-3">Global Community</h3>
          <p className="text-[#5E4022]/80 text-sm leading-relaxed">
            Join thousands of explorers, students, and researchers sharing discoveries
            from archaeological sites around the world.
          </p>
        </div>

        <div className="bg-white/30 backdrop-blur-sm rounded-xl p-6 border border-[#B98E57]/20">
          <div className="text-2xl text-[#B98E57] mb-3">📖</div>
          <h3 className="text-xl font-serif font-bold text-[#5E4022] mb-3">Educational Impact</h3>
          <p className="text-[#5E4022]/80 text-sm leading-relaxed">
            Bringing ancient history to life for students, teachers, and anyone curious
            about the fascinating world of ancient Egypt.
          </p>
        </div>
      </div>

      {/* Call to Action */}
      <div className="text-center bg-gradient-to-r from-[#B98E57]/20 to-[#5E4022]/20 rounded-2xl p-8 border border-[#B98E57]/20">
        <div className="text-3xl text-[#B98E57] mb-4">🚀</div>
        <h2 className="text-2xl font-serif font-bold text-[#5E4022] mb-4">
          Ready to Unlock Ancient Secrets?
        </h2>
        <p className="text-[#5E4022]/80 mb-6 max-w-2xl mx-auto">
          Start your journey into the world of ancient Egypt. Upload your first hieroglyph image
          and discover the stories waiting to be told.
        </p>

        <div className="flex flex-col sm:flex-row gap-4 justify-center">
          <Link to="/upload">
            <Button className="bg-gradient-to-r from-[#B98E57] to-[#5E4022] hover:from-[#C69968] hover:to-[#6F4A33] text-white font-serif text-lg px-8 py-3 shadow-lg hover:shadow-xl transition-all duration-300">
              <span className="flex items-center space-x-2">
                <span>📜</span>
                <span>Start Translating</span>
              </span>
            </Button>
          </Link>
          <Link to="/gallery">
            <Button variant="outline" className="border-[#B98E57] text-[#5E4022] hover:bg-[#B98E57]/10 font-serif text-lg px-8 py-3">
              <span className="flex items-center space-x-2">
                <span>🌍</span>
                <span>Explore Gallery</span>
              </span>
            </Button>
          </Link>
        </div>
      </div>

      {/* Decorative bottom elements */}
      <div className="flex justify-center items-center space-x-8 text-[#B98E57]/40 text-2xl mt-12">
        <span>𓈖</span>
        <span>𓇳</span>
        <span>𓊨</span>
        <span>𓋹</span>
        <span>𓌻</span>
      </div>
    </div>
  );
};

export default About;
