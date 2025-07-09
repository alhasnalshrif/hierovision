
const Footer = () => {
  return (
    <footer className="relative bg-[#5E4022]/10 border-t border-[#B98E57]/30 px-6 py-8 mt-16">
      <div className="container mx-auto">
        {/* Decorative lotus flowers */}
        <div className="absolute top-4 left-8 text-2xl text-[#B98E57]/50">🪷</div>
        <div className="absolute top-4 right-8 text-2xl text-[#B98E57]/50">🪷</div>
        
        <div className="text-center">
          <div className="flex items-center justify-center space-x-2 mb-4">
            <span className="text-[#B98E57] text-xl">𓂀</span>
            <h3 className="text-xl font-serif font-bold text-[#5E4022]">HieroVision</h3>
            <span className="text-[#B98E57] text-xl">𓂀</span>
          </div>
          
          <p className="text-[#5E4022]/70 mb-4 max-w-md mx-auto font-light">
            Bridging the ancient world with modern AI to unlock the secrets of Egyptian hieroglyphs
          </p>
          
          <div className="flex justify-center space-x-6 text-sm text-[#5E4022]/60">
            <span>© 2024 HieroVision</span>
            <span>•</span>
            <span>Powered by AI</span>
            <span>•</span>
            <span>Ancient Wisdom</span>
          </div>
        </div>
        
        {/* Eye of Horus */}
        <div className="absolute bottom-4 left-1/2 transform -translate-x-1/2 text-[#B98E57]/30 text-lg">
          𓂀
        </div>
      </div>
    </footer>
  );
};

export default Footer;
