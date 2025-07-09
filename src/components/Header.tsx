import { Link, useLocation } from "react-router-dom";
import { cn } from "@/lib/utils";
import { useState } from "react";
import { useAuth } from "@/hooks/useAuth";
import { Button } from "@/components/ui/button";

const Header = () => {
  const location = useLocation();
  const [isMobileMenuOpen, setIsMobileMenuOpen] = useState(false);
  const { user, logout } = useAuth();

  const navItems = [
    { path: "/", label: "Home" },
    { path: "/upload", label: "Upload" },
    { path: "/landmarks", label: "Landmarks" },
    { path: "/chat", label: "AnubAI" },
    { path: "/kids", label: "Kids Mode" },
    { path: "/booking", label: "Book Tours" },
    { path: "/history", label: "History" },
    { path: "/about", label: "About" },
  ];

  return (
    <header className="relative bg-gradient-to-r from-[#B98E57]/20 to-[#5E4022]/20 backdrop-blur-sm border-b border-[#B98E57]/30 px-6 py-4">
      <div className="container mx-auto flex items-center justify-between">
        {/* Logo and Title */}
        <Link to="/" className="flex items-center space-x-3 group">
          <div className="w-12 h-12 bg-gradient-to-br from-[#B98E57] to-[#5E4022] rounded-full flex items-center justify-center shadow-lg group-hover:shadow-xl transition-all duration-300">
            <span className="text-white text-2xl font-bold">𓂀</span>
          </div>
          <div>
            <h1 className="text-2xl md:text-3xl font-serif font-bold text-[#5E4022] tracking-wide">
              HieroVision
            </h1>
            <p className="text-xs text-[#5E4022]/70 font-light">Ancient Egypt Decoded</p>
          </div>
        </Link>

        {/* Desktop Navigation */}
        <nav className="hidden lg:flex items-center space-x-6">
          {navItems.map((item) => (
            <Link
              key={item.path}
              to={item.path}
              className={cn(
                "flex items-center space-x-2 px-4 py-2 rounded-lg font-medium transition-all duration-300 relative",
                "hover:bg-[#B98E57]/20 hover:text-[#5E4022] hover:shadow-md",
                location.pathname === item.path
                  ? "bg-[#B98E57]/30 text-[#5E4022] shadow-md"
                  : "text-[#5E4022]/80"
              )}
            >
              <span className="font-serif">{item.label}</span>
              {location.pathname === item.path && (
                <div className="absolute bottom-0 left-1/2 transform -translate-x-1/2 w-6 h-0.5 bg-[#B98E57] rounded-full"></div>
              )}
            </Link>
          ))}

          {/* Auth Section */}
          <div className="flex items-center space-x-4 ml-6 border-l border-[#B98E57]/30 pl-6">
            {user ? (
              <>
                <Link
                  to="/profile"
                  className="flex items-center space-x-2 px-4 py-2 rounded-lg font-medium transition-all duration-300 hover:bg-[#B98E57]/20 text-[#5E4022]/80 hover:text-[#5E4022]"
                >
                  <span>👤</span>
                  <span className="font-serif">{user.name}</span>
                </Link>
                <Button
                  onClick={logout}
                  variant="outline"
                  size="sm"
                  className="border-[#B98E57] text-[#B98E57] hover:bg-[#B98E57] hover:text-white font-serif"
                >
                  Logout
                </Button>
              </>
            ) : (
              <>
                <Link to="/login">
                  <Button
                    variant="outline"
                    size="sm"
                    className="border-[#B98E57] text-[#B98E57] hover:bg-[#B98E57] hover:text-white font-serif"
                  >
                    Login
                  </Button>
                </Link>
                <Link to="/signup">
                  <Button
                    size="sm"
                    className="bg-gradient-to-r from-[#B98E57] to-[#5E4022] hover:from-[#5E4022] hover:to-[#B98E57] text-white font-serif"
                  >
                    Sign Up
                  </Button>
                </Link>
              </>
            )}
          </div>
        </nav>

        {/* Mobile Menu Button */}
        <button
          className="lg:hidden p-2 rounded-lg hover:bg-[#B98E57]/20 transition-colors"
          onClick={() => setIsMobileMenuOpen(!isMobileMenuOpen)}
        >
          <div className="w-6 h-6 flex flex-col justify-center space-y-1">
            <span className={`w-full h-0.5 bg-[#5E4022] rounded transition-all duration-300 ${isMobileMenuOpen ? 'rotate-45 translate-y-1.5' : ''}`}></span>
            <span className={`w-full h-0.5 bg-[#5E4022] rounded transition-all duration-300 ${isMobileMenuOpen ? 'opacity-0' : ''}`}></span>
            <span className={`w-full h-0.5 bg-[#5E4022] rounded transition-all duration-300 ${isMobileMenuOpen ? '-rotate-45 -translate-y-1.5' : ''}`}></span>
          </div>
        </button>
      </div>

      {/* Mobile Menu */}
      {isMobileMenuOpen && (
        <div className="lg:hidden absolute top-full left-0 right-0 bg-[#F5E9D3]/95 backdrop-blur-sm border-b border-[#B98E57]/30 shadow-lg z-50">
          <nav className="container mx-auto px-6 py-4 space-y-2">
            {navItems.map((item) => (
              <Link
                key={item.path}
                to={item.path}
                onClick={() => setIsMobileMenuOpen(false)}
                className={cn(
                  "flex items-center space-x-3 px-4 py-3 rounded-lg font-medium transition-all duration-300 w-full",
                  "hover:bg-[#B98E57]/20 hover:text-[#5E4022]",
                  location.pathname === item.path
                    ? "bg-[#B98E57]/30 text-[#5E4022] shadow-md"
                    : "text-[#5E4022]/80"
                )}
              >
                <span className="font-serif">{item.label}</span>
              </Link>
            ))}

            {/* Mobile Auth Section */}
            <div className="border-t border-[#B98E57]/30 pt-4 mt-4 space-y-2">
              {user ? (
                <>
                  <Link
                    to="/profile"
                    onClick={() => setIsMobileMenuOpen(false)}
                    className="flex items-center space-x-3 px-4 py-3 rounded-lg font-medium transition-all duration-300 w-full hover:bg-[#B98E57]/20 text-[#5E4022]/80 hover:text-[#5E4022]"
                  >
                    <span className="font-serif">{user.name}</span>
                  </Link>
                  <button
                    onClick={() => {
                      logout();
                      setIsMobileMenuOpen(false);
                    }}
                    className="flex items-center space-x-3 px-4 py-3 rounded-lg font-medium transition-all duration-300 w-full hover:bg-[#B98E57]/20 text-[#5E4022]/80 hover:text-[#5E4022]"
                  >
                    <span className="font-serif">Logout</span>
                  </button>
                </>
              ) : (
                <>
                  <Link
                    to="/login"
                    onClick={() => setIsMobileMenuOpen(false)}
                    className="flex items-center space-x-3 px-4 py-3 rounded-lg font-medium transition-all duration-300 w-full hover:bg-[#B98E57]/20 text-[#5E4022]/80 hover:text-[#5E4022]"
                  >
                    <span className="font-serif">Login</span>
                  </Link>
                  <Link
                    to="/signup"
                    onClick={() => setIsMobileMenuOpen(false)}
                    className="flex items-center space-x-3 px-4 py-3 rounded-lg font-medium transition-all duration-300 w-full hover:bg-[#B98E57]/20 text-[#5E4022]/80 hover:text-[#5E4022]"
                  >
                    <span className="font-serif">Sign Up</span>
                  </Link>
                </>
              )}
            </div>
          </nav>
        </div>
      )}

      {/* Decorative border */}
      <div className="absolute bottom-0 left-0 right-0 h-px bg-gradient-to-r from-transparent via-[#B98E57] to-transparent"></div>
    </header>
  );
};

export default Header;
