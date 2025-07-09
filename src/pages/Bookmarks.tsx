import { useState } from "react";
import { Button } from "@/components/ui/button";
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import { Badge } from "@/components/ui/badge";
import { StarRating } from "@/components/ui/star-rating";
import { useBookmarks } from "@/hooks/useBookmarks";
import { useLandmarks } from "@/hooks/useLandmarks";
import { useAuth } from "@/hooks/useAuth";
import { Heart, MapPin, Trash2, Eye } from "lucide-react";
import { toast } from "sonner";

const Bookmarks = () => {
  const { user } = useAuth();
  const { bookmarks, loading: bookmarksLoading, removeBookmark } = useBookmarks();
  const { landmarks, loading: landmarksLoading } = useLandmarks();
  const [removingBookmark, setRemovingBookmark] = useState<string | null>(null);

  // Get landmark details for each bookmark
  const bookmarkedLandmarks = bookmarks
    .map(bookmark => {
      const landmark = landmarks.find(l => l.id === bookmark.landmark_id);
      return landmark ? { ...landmark, bookmarkId: bookmark.id } : null;
    })
    .filter(Boolean);

  const handleRemoveBookmark = async (landmarkId: string) => {
    try {
      setRemovingBookmark(landmarkId);
      await removeBookmark(landmarkId);
      toast.success("Removed from bookmarks");
    } catch (error) {
      toast.error("Failed to remove bookmark");
    } finally {
      setRemovingBookmark(null);
    }
  };

  if (!user) {
    return (
      <div className="container mx-auto px-6 py-16">
        <div className="text-center">
          <div className="text-4xl text-[#B98E57] mb-4">🔐</div>
          <h1 className="text-4xl md:text-5xl font-serif font-bold text-[#5E4022] mb-4">
            Login Required
          </h1>
          <p className="text-lg text-[#5E4022]/70 mb-8">
            Please log in to view your bookmarked landmarks
          </p>
          <Button className="bg-gradient-to-r from-[#B98E57] to-[#5E4022] text-white font-serif">
            Log In
          </Button>
        </div>
      </div>
    );
  }

  if (bookmarksLoading || landmarksLoading) {
    return (
      <div className="container mx-auto px-6 py-16">
        <div className="text-center">
          <div className="text-4xl text-[#B98E57] mb-4">💾</div>
          <h1 className="text-4xl md:text-5xl font-serif font-bold text-[#5E4022] mb-4">
            Loading Your Bookmarks...
          </h1>
        </div>
      </div>
    );
  }

  return (
    <div className="container mx-auto px-6 py-16">
      {/* Header */}
      <div className="text-center mb-12">
        <div className="text-4xl text-[#B98E57] mb-4">💾</div>
        <h1 className="text-4xl md:text-5xl font-serif font-bold text-[#5E4022] mb-4">
          Your Bookmarked Landmarks
        </h1>
        <p className="text-lg text-[#5E4022]/70 max-w-3xl mx-auto">
          Keep track of the ancient Egyptian sites you want to visit and explore
        </p>
      </div>

      {/* Bookmarks Count */}
      <div className="text-center mb-8">
        <div className="inline-flex items-center space-x-2 bg-white/20 backdrop-blur-sm rounded-full px-6 py-3 border border-[#B98E57]/20">
          <Heart className="w-5 h-5 text-red-500 fill-current" />
          <span className="text-[#5E4022] font-serif">
            {bookmarkedLandmarks.length} landmark{bookmarkedLandmarks.length !== 1 ? 's' : ''} saved
          </span>
        </div>
      </div>

      {/* Bookmarks Grid */}
      {bookmarkedLandmarks.length === 0 ? (
        <div className="text-center py-16">
          <div className="text-6xl text-[#B98E57]/50 mb-6">💔</div>
          <h2 className="text-2xl font-serif font-bold text-[#5E4022] mb-4">
            No bookmarks yet
          </h2>
          <p className="text-[#5E4022]/70 mb-8 max-w-md mx-auto">
            Start exploring landmarks and bookmark the ones you'd like to visit!
          </p>
          <Button className="bg-gradient-to-r from-[#B98E57] to-[#5E4022] text-white font-serif">
            Explore Landmarks
          </Button>
        </div>
      ) : (
        <div className="grid md:grid-cols-2 lg:grid-cols-3 gap-8">
          {bookmarkedLandmarks.map((landmark) => (
            <Card
              key={landmark.id}
              className="group bg-white/20 backdrop-blur-sm border border-[#B98E57]/20 hover:border-[#B98E57] transition-all duration-300 hover:shadow-xl overflow-hidden"
            >
              {/* Egyptian frame decoration */}
              <div className="relative">
                <div className="absolute top-2 left-2 text-[#B98E57]/40 text-xl z-10">𓍝</div>
                <div className="absolute top-2 right-2 z-10 flex space-x-2">
                  <Button
                    variant="ghost"
                    size="sm"
                    className="p-2 rounded-full bg-white/80 text-gray-600 hover:bg-white hover:text-blue-600 transition-all duration-300"
                    onClick={() => {/* Navigate to landmark detail */}}
                  >
                    <Eye className="w-4 h-4" />
                  </Button>
                  <Button
                    variant="ghost"
                    size="sm"
                    className="p-2 rounded-full bg-white/80 text-gray-600 hover:bg-white hover:text-red-600 transition-all duration-300"
                    onClick={() => handleRemoveBookmark(landmark.id)}
                    disabled={removingBookmark === landmark.id}
                  >
                    {removingBookmark === landmark.id ? (
                      <div className="w-4 h-4 border-2 border-red-500 border-t-transparent rounded-full animate-spin" />
                    ) : (
                      <Trash2 className="w-4 h-4" />
                    )}
                  </Button>
                </div>
                <div className="absolute bottom-2 left-2 text-[#B98E57]/40 text-xl z-10">𓍝</div>
                <div className="absolute bottom-2 right-2 text-[#B98E57]/40 text-xl z-10">𓍝</div>
                
                <img
                  src={landmark.image}
                  alt={landmark.name}
                  className="w-full h-48 object-cover group-hover:scale-105 transition-transform duration-300"
                />
                
                {/* Hieroglyph overlay */}
                <div className="absolute bottom-4 right-4 bg-[#5E4022]/80 text-[#B98E57] px-3 py-1 rounded-lg font-serif">
                  {landmark.hieroglyphName}
                </div>
              </div>
              
              <CardHeader>
                <CardTitle className="font-serif text-[#5E4022] group-hover:text-[#B98E57] transition-colors">
                  {landmark.name}
                </CardTitle>
                <div className="flex gap-2 flex-wrap">
                  <Badge variant="outline" className="border-[#B98E57]/50 text-[#5E4022] flex items-center gap-1">
                    <MapPin className="w-3 h-3" />
                    {landmark.location}
                  </Badge>
                  <Badge variant="outline" className="border-[#B98E57]/50 text-[#5E4022] capitalize">
                    {landmark.type}
                  </Badge>
                </div>
                
                {/* Rating and Price */}
                <div className="flex items-center justify-between mt-2">
                  <div className="flex items-center space-x-2">
                    <StarRating rating={landmark.averageRating || 0} readonly size="sm" />
                    <span className="text-sm text-[#5E4022]/70">
                      ({landmark.reviewCount || 0})
                    </span>
                  </div>
                  <div className="text-sm font-bold text-[#B98E57]">
                    ${landmark.price}/person
                  </div>
                </div>
              </CardHeader>
              
              <CardContent>
                <p className="text-[#5E4022]/70 text-sm leading-relaxed mb-4">
                  {landmark.description.substring(0, 120)}...
                </p>
                
                <div className="flex gap-2">
                  <Button 
                    size="sm" 
                    className="flex-1 bg-gradient-to-r from-[#B98E57] to-[#5E4022] text-white font-serif"
                  >
                    Book Visit
                  </Button>
                  <Button 
                    variant="outline" 
                    size="sm"
                    className="border-[#5E4022] text-[#5E4022] font-serif"
                  >
                    Details
                  </Button>
                </div>
              </CardContent>
            </Card>
          ))}
        </div>
      )}
    </div>
  );
};

export default Bookmarks;
