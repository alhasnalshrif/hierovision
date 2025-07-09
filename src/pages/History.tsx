
import { useState, useEffect } from "react";
import { Link } from "react-router-dom";
import { Button } from "@/components/ui/button";
import { useToast } from "@/hooks/use-toast";
import { apiService } from "@/services/api";
import { useAuth } from "@/hooks/useAuth";
import { Loader2 } from "lucide-react";

const History = () => {
  const { toast } = useToast();
  const { user } = useAuth();
  const [selectedItem, setSelectedItem] = useState<number | null>(null);
  const [historyItems, setHistoryItems] = useState<any[]>([]);
  const [isLoading, setIsLoading] = useState(true);

  useEffect(() => {
    if (user) {
      loadHistory();
    } else {
      setIsLoading(false);
    }
  }, [user]);

  const loadHistory = async () => {
    try {
      setIsLoading(true);
      const response = await apiService.getUserScans() as { success: boolean; scans: any[] };
      
      console.log('History data received:', response); // Debug log
      
      if (response.success) {
        setHistoryItems(response.scans || []);
      }
    } catch (error) {
      console.error('Load history error:', error);
      toast({
        title: "Failed to load history",
        description: "Unable to retrieve your scan history.",
        variant: "destructive",
      });
    } finally {
      setIsLoading(false);
    }
  };

  const getIconForType = (type: string) => {
    switch (type) {
      case "temple": return "🏛️";
      case "tomb": return "⚱️";
      case "pyramid": return "🔺";
      case "papyrus": return "📜";
      default: return "🏺";
    }
  };

  const formatDate = (timestamp: string) => {
    if (!timestamp) return { date: 'Unknown', time: 'Unknown' };
    const date = new Date(timestamp);
    return {
      date: date.toLocaleDateString(),
      time: date.toLocaleTimeString([], { hour: '2-digit', minute: '2-digit' })
    };
  };

  const getConfidencePercentage = (confidenceScore: number) => {
    if (!confidenceScore) return 0;
    // If confidence is already a percentage (> 1), return as is
    // If it's a decimal (≤ 1), convert to percentage
    return confidenceScore > 1 ? Math.round(confidenceScore) : Math.round(confidenceScore * 100);
  };

  const handleViewDetails = (item: any) => {
    setSelectedItem(item.id);
    toast({
      title: "Translation Details",
      description: `Viewing details for: ${item.description || 'Hieroglyph translation'}`,
    });
  };

  const handleDownload = (item: any) => {
    toast({
      title: "Download Started",
      description: `Downloading translation: ${item.description || 'Hieroglyph translation'}`,
    });
  };

  // Loading state
  if (isLoading) {
    return (
      <div className="container mx-auto px-6 py-16 max-w-6xl">
        <div className="text-center">
          <Loader2 className="h-8 w-8 animate-spin mx-auto mb-4 text-[#B98E57]" />
          <h1 className="text-2xl font-serif font-bold text-[#5E4022] mb-4">
            Loading History...
          </h1>
        </div>
      </div>
    );
  }

  // Not authenticated
  if (!user) {
    return (
      <div className="container mx-auto px-6 py-16 max-w-6xl">
        <div className="text-center">
          <div className="text-4xl text-[#B98E57] mb-4">🔒</div>
          <h1 className="text-4xl md:text-5xl font-serif font-bold text-[#5E4022] mb-4">
            Login Required
          </h1>
          <p className="text-lg text-[#5E4022]/70 max-w-2xl mx-auto mb-8">
            Please login to view your translation history.
          </p>
          <Link to="/login">
            <Button className="bg-[#B98E57] hover:bg-[#C69968] text-white font-serif">
              Login Now
            </Button>
          </Link>
        </div>
      </div>
    );
  }

  return (
    <div className="container mx-auto px-6 py-16 max-w-6xl">
      {/* Header */}
      <div className="text-center mb-12">
        <div className="text-4xl text-[#B98E57] mb-4">📚</div>
        <h1 className="text-4xl md:text-5xl font-serif font-bold text-[#5E4022] mb-4">
          My Translation History
        </h1>
        <p className="text-lg text-[#5E4022]/70 max-w-2xl mx-auto">
          Revisit your journey through ancient Egyptian wisdom. Each translation tells a story from the past.
        </p>
      </div>

      {/* Stats Summary */}
      {historyItems.length > 0 ? (
        <div className="grid md:grid-cols-3 gap-6 mb-12">
          <div className="bg-white/30 backdrop-blur-sm rounded-xl p-6 border border-[#B98E57]/20 text-center">
            <div className="text-3xl text-[#B98E57] mb-2">📊</div>
            <div className="text-2xl font-serif font-bold text-[#5E4022]">{historyItems.length}</div>
            <p className="text-[#5E4022]/70">Total Translations</p>
          </div>
          <div className="bg-white/30 backdrop-blur-sm rounded-xl p-6 border border-[#B98E57]/20 text-center">
            <div className="text-3xl text-[#B98E57] mb-2">🎯</div>
            <div className="text-2xl font-serif font-bold text-[#5E4022]">
              {historyItems.length > 0 ? Math.round(historyItems.reduce((acc, item) => acc + getConfidencePercentage(item.confidence_score || 0), 0) / historyItems.length) : 0}%
            </div>
            <p className="text-[#5E4022]/70">Average Accuracy</p>
          </div>
          <div className="bg-white/30 backdrop-blur-sm rounded-xl p-6 border border-[#B98E57]/20 text-center">
            <div className="text-3xl text-[#B98E57] mb-2">🏛️</div>
            <div className="text-2xl font-serif font-bold text-[#5E4022]">
              {historyItems.length}
            </div>
            <p className="text-[#5E4022]/70">Unique Translations</p>
          </div>
        </div>
      ) : null}

      {/* History Grid */}
      {historyItems.length > 0 ? (
        <div className="grid md:grid-cols-2 lg:grid-cols-3 gap-6 mb-12">
          {historyItems.map((item) => {
            const { date, time } = formatDate(item.timestamp);
            const confidence = getConfidencePercentage(item.confidence_score || 0);
            
            return (
            <div
              key={item.id}
              className={`group relative bg-white/30 backdrop-blur-sm rounded-2xl p-6 border border-[#B98E57]/20 shadow-lg hover:shadow-xl transition-all duration-300 cursor-pointer ${
                selectedItem === item.id ? 'ring-2 ring-[#B98E57] scale-105' : 'hover:scale-102'
              }`}
              onClick={() => handleViewDetails(item)}
          >
            {/* Egyptian border decorations */}
            <div className="absolute top-2 left-2 text-[#B98E57]/30 text-sm">𓍝</div>
            <div className="absolute top-2 right-2 text-[#B98E57]/30 text-sm">𓍝</div>
            <div className="absolute bottom-2 left-2 text-[#B98E57]/30 text-sm">𓍝</div>
            <div className="absolute bottom-2 right-2 text-[#B98E57]/30 text-sm">𓍝</div>

            {/* Type indicator */}
            <div className="flex items-center justify-between mb-4">
              <span className="text-2xl">{getIconForType(item.type || 'hieroglyph')}</span>
              <div className="text-right">
                <div className="text-xs text-[#5E4022]/60 font-serif">{date}</div>
                <div className="text-xs text-[#5E4022]/60 font-serif">{time}</div>
              </div>
            </div>

            {/* Hieroglyph preview */}
            <div className="bg-[#F5E9D3]/50 rounded-xl p-4 mb-4 min-h-[80px] flex items-center justify-center border border-[#B98E57]/20">
              <div className="text-3xl text-[#5E4022] text-center leading-relaxed">
                {item.image || '𓊪 𓏏 𓇯'}
              </div>
            </div>

            {/* Translation preview */}
            <div className="mb-4">
              <h3 className="font-serif font-bold text-[#5E4022] mb-2 line-clamp-2">
                {item.description || 'Hieroglyph Translation'}
              </h3>
              <p className="text-sm text-[#5E4022]/70 font-serif">
                📍 {item.location || 'Ancient Egypt'}
              </p>
            </div>

            {/* Confidence indicator */}
            <div className="flex items-center justify-between mb-4">
              <span className="text-sm text-[#5E4022]/60">Confidence</span>
              <div className="flex items-center space-x-2">
                <div className="w-16 h-2 bg-[#5E4022]/20 rounded-full overflow-hidden">
                  <div 
                    className="h-full bg-gradient-to-r from-[#B98E57] to-[#5E4022] transition-all duration-500"
                    style={{ width: `${confidence}%` }}
                  />
                </div>
                <span className="text-sm font-bold text-[#5E4022]">{confidence}%</span>
              </div>
            </div>

            {/* Action buttons */}
            <div className="flex gap-2">
              <Button
                onClick={(e) => {
                  e.stopPropagation();
                  handleViewDetails(item);
                }}
                size="sm"
                className="flex-1 bg-[#B98E57] hover:bg-[#C69968] text-white font-serif text-xs"
              >
                View Details
              </Button>
              <Button
                onClick={(e) => {
                  e.stopPropagation();
                  handleDownload(item);
                }}
                size="sm"
                variant="outline"
                className="border-[#5E4022] text-[#5E4022] hover:bg-[#5E4022]/10 font-serif text-xs"
              >
                📄
              </Button>
            </div>
          </div>
          );
        })}
        </div>
      ) : (
        // Empty state
        <div className="text-center py-16">
          <div className="text-6xl text-[#B98E57]/50 mb-6">📜</div>
          <h3 className="text-2xl font-serif font-bold text-[#5E4022] mb-4">
            No Translations Yet
          </h3>
          <p className="text-[#5E4022]/70 mb-8 max-w-md mx-auto">
            Start your journey into ancient Egyptian wisdom by uploading your first hieroglyph image.
          </p>
          <Link to="/upload">
            <Button className="bg-[#B98E57] hover:bg-[#C69968] text-white font-serif">
              Upload First Image
            </Button>
          </Link>
        </div>
      )}

      {/* Modal/Details view */}
      {selectedItem && (
        <div className="fixed inset-0 bg-black/50 backdrop-blur-sm z-50 flex items-center justify-center p-4">
          <div className="bg-gradient-to-br from-[#F5E9D3] to-[#E3D2B7] rounded-2xl p-8 max-w-2xl w-full max-h-[80vh] overflow-y-auto border-2 border-[#B98E57]/30 shadow-2xl">
            <div className="flex justify-between items-start mb-6">
              <h2 className="text-2xl font-serif font-bold text-[#5E4022]">
                Translation Details
              </h2>
              <Button
                onClick={() => setSelectedItem(null)}
                variant="outline"
                size="sm"
                className="border-[#5E4022] text-[#5E4022] hover:bg-[#5E4022]/10"
              >
                ✕
              </Button>
            </div>

            {(() => {
              const item = historyItems.find(h => h.id === selectedItem);
              if (!item) return null;

              const { date, time } = formatDate(item.timestamp);
              const confidence = getConfidencePercentage(item.confidence_score || 0);

              return (
                <div className="space-y-6">
                  <div className="bg-white/40 backdrop-blur-sm rounded-xl p-6 border border-[#B98E57]/20">
                    <div className="text-center mb-4">
                      <div className="text-4xl text-[#5E4022] mb-2">{item.image || '𓊪 𓏏 𓇯'}</div>
                      <p className="text-sm text-[#5E4022]/60 font-serif">
                        {item.location || 'Ancient Egypt'} • {date} at {time}
                      </p>
                      <div className="mt-2">
                        <span className="inline-block bg-[#B98E57]/20 text-[#5E4022] px-3 py-1 rounded-full text-sm font-serif">
                          Confidence: {confidence}%
                        </span>
                      </div>
                    </div>
                    <p className="text-lg font-serif text-[#5E4022] italic text-center">
                      "{item.description || 'Ancient hieroglyphic translation'}"
                    </p>
                  </div>

                
                </div>
              );
            })()}
          </div>
        </div>
      )}

      {/* Action Buttons */}
      <div className="text-center">
        <Link to="/upload">
          <Button className="bg-gradient-to-r from-[#B98E57] to-[#5E4022] hover:from-[#C69968] hover:to-[#6F4A33] text-white font-serif text-lg px-8 py-3 shadow-lg hover:shadow-xl transition-all duration-300">
            <span className="flex items-center space-x-2">
              <span>📜</span>
              <span>Translate New Image</span>
            </span>
          </Button>
        </Link>
      </div>
    </div>
  );
};

export default History;
