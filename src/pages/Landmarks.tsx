
import { useState } from "react";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Badge } from "@/components/ui/badge";
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import { StarRating } from "@/components/ui/star-rating";
import { ReviewComponent } from "@/components/ReviewComponent";
import { useLandmarks, Landmark } from "@/hooks/useLandmarks";
import { useBookmarks } from "@/hooks/useBookmarks";
import { useReviews } from "@/hooks/useReviews";
import { useAuth } from "@/hooks/useAuth";
import { Heart, BookOpen, MapPin, Users } from "lucide-react";
import { toast } from "sonner";

const Landmarks = () => {
  const [searchTerm, setSearchTerm] = useState("");
  const [selectedType, setSelectedType] = useState("all");
  const [selectedLandmark, setSelectedLandmark] = useState<Landmark | null>(null);
  
  const { landmarks, loading: landmarksLoading, error: landmarksError } = useLandmarks();
  const { isBookmarked, toggleBookmark } = useBookmarks();
  const { user } = useAuth();
  
  // Reviews hook for selected landmark
  const { 
    reviews, 
    addReview, 
    updateReview, 
    deleteReview, 
    getUserReview,
    loading: reviewsLoading 
  } = useReviews(selectedLandmark?.id || "");

  const filteredLandmarks = landmarks.filter(landmark => {
    const matchesSearch = landmark.name.toLowerCase().includes(searchTerm.toLowerCase()) ||
                         landmark.location.toLowerCase().includes(searchTerm.toLowerCase());
    const matchesType = selectedType === "all" || landmark.type === selectedType;
    return matchesSearch && matchesType;
  });

  const handleBookmarkToggle = async (landmarkId: string, e: React.MouseEvent) => {
    e.stopPropagation();
    
    if (!user) {
      toast.error("Please log in to bookmark landmarks");
      return;
    }

    try {
      await toggleBookmark(landmarkId);
      toast.success(
        isBookmarked(landmarkId) 
          ? "Removed from bookmarks" 
          : "Added to bookmarks"
      );
    } catch (error) {
      toast.error("Failed to update bookmark");
    }
  };

  if (landmarksLoading) {
    return (
      <div className="container mx-auto px-6 py-16">
        <div className="text-center">
          <div className="text-4xl text-[#B98E57] mb-4">🏛️</div>
          <h1 className="text-4xl md:text-5xl font-serif font-bold text-[#5E4022] mb-4">
            Loading Landmarks...
          </h1>
        </div>
      </div>
    );
  }

  if (landmarksError) {
    return (
      <div className="container mx-auto px-6 py-16">
        <div className="text-center">
          <div className="text-4xl text-red-500 mb-4">⚠️</div>
          <h1 className="text-4xl md:text-5xl font-serif font-bold text-[#5E4022] mb-4">
            Error Loading Landmarks
          </h1>
          <p className="text-lg text-[#5E4022]/70">{landmarksError}</p>
        </div>
      </div>
    );
  }

  return (
    <div className="container mx-auto px-6 py-16">
      {/* Header */}
      <div className="text-center mb-12">
        <div className="text-4xl text-[#B98E57] mb-4">🏛️</div>
        <h1 className="text-4xl md:text-5xl font-serif font-bold text-[#5E4022] mb-4">
          Ancient Egyptian Landmarks
        </h1>
        <p className="text-lg text-[#5E4022]/70 max-w-3xl mx-auto">
          Explore the magnificent monuments and sacred sites that have stood for millennia, 
          each telling the story of one of history's greatest civilizations.
        </p>
      </div>

      {/* Search and Filter */}
      <div className="mb-12 bg-white/20 backdrop-blur-sm rounded-2xl p-6 border border-[#B98E57]/20">
        <div className="flex flex-col md:flex-row gap-4 items-center">
          <div className="flex-1">
            <Input
              placeholder="Search landmarks or locations..."
              value={searchTerm}
              onChange={(e) => setSearchTerm(e.target.value)}
              className="bg-white/50 border-[#B98E57]/30 focus:border-[#B98E57] font-serif"
            />
          </div>
          <div className="flex gap-2 flex-wrap">
            {["all", "pyramid", "temple", "tomb"].map((type) => (
              <Button
                key={type}
                variant={selectedType === type ? "default" : "outline"}
                onClick={() => setSelectedType(type)}
                className={`font-serif capitalize ${
                  selectedType === type
                    ? "bg-[#B98E57] text-white"
                    : "border-[#B98E57] text-[#5E4022] hover:bg-[#B98E57]/10"
                }`}
              >
                {type}
              </Button>
            ))}
          </div>
        </div>
      </div>

      {/* Landmarks Grid */}
      <div className="grid md:grid-cols-2 lg:grid-cols-3 gap-8 mb-16">
        {filteredLandmarks.map((landmark) => (
          <Card
            key={landmark.id}
            className="group cursor-pointer bg-white/20 backdrop-blur-sm border border-[#B98E57]/20 hover:border-[#B98E57] transition-all duration-300 hover:shadow-xl overflow-hidden"
            onClick={() => setSelectedLandmark(landmark)}
          >
            {/* Egyptian frame decoration */}
            <div className="relative">
              <div className="absolute top-2 left-2 text-[#B98E57]/40 text-xl z-10">𓍝</div>
              <div className="absolute top-2 right-2 z-10">
                <Button
                  variant="ghost"
                  size="sm"
                  className={`p-2 rounded-full transition-all duration-300 ${
                    isBookmarked(landmark.id)
                      ? "bg-red-100 text-red-500 hover:bg-red-200"
                      : "bg-white/80 text-gray-400 hover:bg-white hover:text-red-500"
                  }`}
                  onClick={(e) => handleBookmarkToggle(landmark.id, e)}
                >
                  <Heart className={`w-4 h-4 ${isBookmarked(landmark.id) ? "fill-current" : ""}`} />
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
              
              {/* Rating and Reviews */}
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
              <p className="text-[#5E4022]/70 text-sm leading-relaxed">
                {landmark.description.substring(0, 120)}...
              </p>
            </CardContent>
          </Card>
        ))}
      </div>

      {/* Landmark Detail Modal */}
      {selectedLandmark && (
        <div className="fixed inset-0 bg-black/50 flex items-center justify-center p-4 z-50">
          <div className="bg-[#F5E9D3] rounded-2xl max-w-6xl w-full max-h-[90vh] overflow-y-auto relative border-4 border-[#B98E57]">
            {/* Close button */}
            <button
              onClick={() => setSelectedLandmark(null)}
              className="absolute top-4 right-4 text-[#5E4022] hover:text-[#B98E57] text-2xl z-10"
            >
              ✕
            </button>
            
            {/* Modal content */}
            <div className="p-8">
              <div className="grid lg:grid-cols-2 gap-8 mb-8">
                <div>
                  <div className="relative rounded-xl overflow-hidden shadow-2xl">
                    <img
                      src={selectedLandmark.image}
                      alt={selectedLandmark.name}
                      className="w-full h-64 md:h-80 object-cover"
                    />
                    <div className="absolute inset-0 bg-gradient-to-t from-[#5E4022]/20 to-transparent"></div>
                    
                    {/* Bookmark button in modal */}
                    <div className="absolute top-4 right-4">
                      <Button
                        variant="ghost"
                        size="sm"
                        className={`p-3 rounded-full transition-all duration-300 ${
                          isBookmarked(selectedLandmark.id)
                            ? "bg-red-100 text-red-500 hover:bg-red-200"
                            : "bg-white/80 text-gray-400 hover:bg-white hover:text-red-500"
                        }`}
                        onClick={(e) => handleBookmarkToggle(selectedLandmark.id, e)}
                      >
                        <Heart className={`w-5 h-5 ${isBookmarked(selectedLandmark.id) ? "fill-current" : ""}`} />
                      </Button>
                    </div>
                  </div>
                </div>
                
                <div className="space-y-6">
                  <div>
                    <div className="text-center mb-4">
                      <div className="text-3xl text-[#B98E57] mb-2">{selectedLandmark.hieroglyphName}</div>
                      <h2 className="text-3xl font-serif font-bold text-[#5E4022]">
                        {selectedLandmark.name}
                      </h2>
                      <p className="text-[#B98E57] font-serif flex items-center justify-center gap-2">
                        <MapPin className="w-4 h-4" />
                        {selectedLandmark.location}
                      </p>
                    </div>
                    
                    {/* Rating and Price */}
                    <div className="flex items-center justify-between mb-4 p-4 bg-white/30 rounded-xl border border-[#B98E57]/20">
                      <div className="flex items-center space-x-3">
                        <StarRating rating={selectedLandmark.averageRating || 0} readonly />
                        <div className="text-[#5E4022]">
                          <div className="font-bold">{(selectedLandmark.averageRating || 0).toFixed(1)}</div>
                          <div className="text-sm opacity-70">
                            ({selectedLandmark.reviewCount || 0} reviews)
                          </div>
                        </div>
                      </div>
                      <div className="text-right">
                        <div className="text-2xl font-bold text-[#B98E57]">
                          ${selectedLandmark.price}
                        </div>
                        <div className="text-sm text-[#5E4022]/70">per person</div>
                      </div>
                    </div>
                    
                    <div className="bg-white/30 rounded-xl p-6 border border-[#B98E57]/20">
                      <p className="text-[#5E4022] leading-relaxed font-serif">
                        {selectedLandmark.description}
                      </p>
                    </div>

                    {/* Tours Available */}
                    {selectedLandmark.tours && selectedLandmark.tours.length > 0 && (
                      <div className="bg-white/30 rounded-xl p-6 border border-[#B98E57]/20">
                        <h4 className="font-serif font-bold text-[#5E4022] mb-3 flex items-center gap-2">
                          <Users className="w-4 h-4" />
                          Available Tours
                        </h4>
                        <div className="flex flex-wrap gap-2">
                          {selectedLandmark.tours.map((tour, index) => (
                            <Badge key={index} variant="outline" className="border-[#B98E57] text-[#5E4022]">
                              {tour}
                            </Badge>
                          ))}
                        </div>
                      </div>
                    )}
                  </div>
                  
                  <div className="flex gap-4">
                    <Button className="flex-1 bg-gradient-to-r from-[#B98E57] to-[#5E4022] text-white font-serif">
                      Book Visit
                    </Button>
                    <Button variant="outline" className="border-[#5E4022] text-[#5E4022] font-serif flex items-center gap-2">
                      <BookOpen className="w-4 h-4" />
                      Learn More
                    </Button>
                  </div>
                </div>
              </div>
              
              {/* Reviews Section */}
              <div className="border-t border-[#B98E57]/30 pt-8">
                <ReviewComponent
                  reviews={reviews}
                  onAddReview={addReview}
                  onUpdateReview={updateReview}
                  onDeleteReview={deleteReview}
                  userReview={getUserReview()}
                  loading={reviewsLoading}
                />
              </div>
            </div>
            
            {/* Decorative elements */}
            <div className="absolute top-4 left-4 text-[#B98E57]/30 text-2xl">𓂀</div>
            <div className="absolute bottom-4 right-4 text-[#B98E57]/30 text-2xl">𓂀</div>
          </div>
        </div>
      )}
    </div>
  );
};

export default Landmarks;
