
import { useState } from "react";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from "@/components/ui/card";
import { Tabs, TabsContent, TabsList, TabsTrigger } from "@/components/ui/tabs";
import { Form, FormControl, FormField, FormItem, FormLabel, FormMessage } from "@/components/ui/form";
import { useForm } from "react-hook-form";

const Profile = () => {
  const [isEditing, setIsEditing] = useState(false);
  
  const form = useForm({
    defaultValues: {
      name: "Explorer of Ancient Wisdom",
      email: "explorer@hierovision.com",
      bio: "Passionate about uncovering the mysteries of ancient Egypt",
    },
  });

  const onSubmit = async (values: any) => {
    // TODO: Implement profile update
    console.log("Profile update:", values);
    setIsEditing(false);
  };

  // Mock data for user activity
  const translations = [
    { id: 1, text: "𓂀 𓇳 𓊨", translation: "Life, Prosperity, Health", date: "2024-01-15" },
    { id: 2, text: "𓋹 𓌻", translation: "Pharaoh's Name", date: "2024-01-14" },
  ];

  const bookmarks = [
    { id: 1, name: "Great Pyramid of Giza", type: "Pyramid", date: "2024-01-10" },
    { id: 2, name: "Temple of Karnak", type: "Temple", date: "2024-01-08" },
  ];

  const bookings = [
    { id: 1, landmark: "Valley of the Kings", date: "2024-02-15", status: "Confirmed" },
    { id: 2, landmark: "Abu Simbel", date: "2024-03-20", status: "Pending" },
  ];

  return (
    <div className="container mx-auto px-6 py-8">
      {/* Header Section */}
      <div className="mb-8 text-center">
        <div className="relative mb-6">
          <div className="w-24 h-24 bg-gradient-to-br from-[#B98E57] to-[#5E4022] rounded-full mx-auto flex items-center justify-center shadow-xl">
            <span className="text-white text-4xl">𓂀</span>
          </div>
          <div className="absolute -bottom-2 -right-2 bg-[#B98E57] text-white text-sm px-2 py-1 rounded-full shadow-lg">
            Seeker
          </div>
        </div>
        <h1 className="text-4xl font-serif font-bold text-[#5E4022] mb-2">
          Your Sacred Profile
        </h1>
        <p className="text-[#5E4022]/70 font-serif">
          Track your journey through ancient wisdom
        </p>
        <div className="flex justify-center space-x-4 mt-4 text-[#B98E57] text-2xl">
          <span className="animate-pulse">𓈖</span>
          <span className="animate-pulse" style={{animationDelay: '0.5s'}}>𓇳</span>
          <span className="animate-pulse" style={{animationDelay: '1s'}}>𓊨</span>
        </div>
      </div>

      <Tabs defaultValue="profile" className="space-y-6">
        <TabsList className="grid w-full grid-cols-4 bg-white/30 backdrop-blur-sm border border-[#B98E57]/30">
          <TabsTrigger value="profile" className="font-serif">Profile</TabsTrigger>
          <TabsTrigger value="translations" className="font-serif">Translations</TabsTrigger>
          <TabsTrigger value="bookmarks" className="font-serif">Bookmarks</TabsTrigger>
          <TabsTrigger value="bookings" className="font-serif">Bookings</TabsTrigger>
        </TabsList>

        {/* Profile Tab */}
        <TabsContent value="profile">
          <Card className="bg-white/30 backdrop-blur-sm border-2 border-[#B98E57]/30 shadow-xl">
            <CardHeader>
              <div className="flex justify-between items-center">
                <div>
                  <CardTitle className="text-2xl font-serif text-[#5E4022] flex items-center space-x-2">
                    <span>👤</span>
                    <span>Personal Information</span>
                  </CardTitle>
                  <CardDescription className="text-[#5E4022]/70">
                    Manage your profile details
                  </CardDescription>
                </div>
                <Button
                  onClick={() => setIsEditing(!isEditing)}
                  variant="outline"
                  className="border-[#B98E57] text-[#B98E57] hover:bg-[#B98E57] hover:text-white"
                >
                  {isEditing ? "Cancel" : "Edit Profile"}
                </Button>
              </div>
            </CardHeader>
            <CardContent>
              {isEditing ? (
                <Form {...form}>
                  <form onSubmit={form.handleSubmit(onSubmit)} className="space-y-6">
                    <FormField
                      control={form.control}
                      name="name"
                      render={({ field }) => (
                        <FormItem>
                          <FormLabel className="text-[#5E4022] font-serif">Name</FormLabel>
                          <FormControl>
                            <Input {...field} className="bg-white/50 border-[#B98E57]/30" />
                          </FormControl>
                          <FormMessage />
                        </FormItem>
                      )}
                    />
                    <FormField
                      control={form.control}
                      name="email"
                      render={({ field }) => (
                        <FormItem>
                          <FormLabel className="text-[#5E4022] font-serif">Email</FormLabel>
                          <FormControl>
                            <Input {...field} type="email" className="bg-white/50 border-[#B98E57]/30" />
                          </FormControl>
                          <FormMessage />
                        </FormItem>
                      )}
                    />
                    <FormField
                      control={form.control}
                      name="bio"
                      render={({ field }) => (
                        <FormItem>
                          <FormLabel className="text-[#5E4022] font-serif">Bio</FormLabel>
                          <FormControl>
                            <Input {...field} className="bg-white/50 border-[#B98E57]/30" />
                          </FormControl>
                          <FormMessage />
                        </FormItem>
                      )}
                    />
                    <Button
                      type="submit"
                      className="bg-gradient-to-r from-[#B98E57] to-[#5E4022] hover:from-[#5E4022] hover:to-[#B98E57] text-white"
                    >
                      Save Changes
                    </Button>
                  </form>
                </Form>
              ) : (
                <div className="space-y-4">
                  <div className="p-4 bg-white/20 rounded-lg border border-[#B98E57]/20">
                    <p className="text-sm text-[#5E4022]/70 font-serif">Name</p>
                    <p className="text-lg text-[#5E4022] font-serif">{form.getValues('name')}</p>
                  </div>
                  <div className="p-4 bg-white/20 rounded-lg border border-[#B98E57]/20">
                    <p className="text-sm text-[#5E4022]/70 font-serif">Email</p>
                    <p className="text-lg text-[#5E4022]">{form.getValues('email')}</p>
                  </div>
                  <div className="p-4 bg-white/20 rounded-lg border border-[#B98E57]/20">
                    <p className="text-sm text-[#5E4022]/70 font-serif">Bio</p>
                    <p className="text-lg text-[#5E4022] font-serif">{form.getValues('bio')}</p>
                  </div>
                </div>
              )}
            </CardContent>
          </Card>
        </TabsContent>

        {/* Translations Tab */}
        <TabsContent value="translations">
          <Card className="bg-white/30 backdrop-blur-sm border-2 border-[#B98E57]/30 shadow-xl">
            <CardHeader>
              <CardTitle className="text-2xl font-serif text-[#5E4022] flex items-center space-x-2">
                <span>📜</span>
                <span>My Translations</span>
              </CardTitle>
              <CardDescription className="text-[#5E4022]/70">
                Your hieroglyph translation history
              </CardDescription>
            </CardHeader>
            <CardContent>
              <div className="space-y-4">
                {translations.map((translation) => (
                  <div key={translation.id} className="p-4 bg-white/20 rounded-lg border border-[#B98E57]/20 hover:bg-white/30 transition-colors">
                    <div className="flex justify-between items-start">
                      <div>
                        <p className="text-2xl text-[#B98E57] mb-2">{translation.text}</p>
                        <p className="text-[#5E4022] font-serif">{translation.translation}</p>
                      </div>
                      <span className="text-sm text-[#5E4022]/70">{translation.date}</span>
                    </div>
                  </div>
                ))}
              </div>
            </CardContent>
          </Card>
        </TabsContent>

        {/* Bookmarks Tab */}
        <TabsContent value="bookmarks">
          <Card className="bg-white/30 backdrop-blur-sm border-2 border-[#B98E57]/30 shadow-xl">
            <CardHeader>
              <CardTitle className="text-2xl font-serif text-[#5E4022] flex items-center space-x-2">
                <span>🔖</span>
                <span>Saved Landmarks</span>
              </CardTitle>
              <CardDescription className="text-[#5E4022]/70">
                Your favorite Egyptian landmarks
              </CardDescription>
            </CardHeader>
            <CardContent>
              <div className="space-y-4">
                {bookmarks.map((bookmark) => (
                  <div key={bookmark.id} className="p-4 bg-white/20 rounded-lg border border-[#B98E57]/20 hover:bg-white/30 transition-colors">
                    <div className="flex justify-between items-center">
                      <div>
                        <h3 className="text-lg font-serif text-[#5E4022]">{bookmark.name}</h3>
                        <p className="text-[#5E4022]/70">{bookmark.type}</p>
                      </div>
                      <span className="text-sm text-[#5E4022]/70">{bookmark.date}</span>
                    </div>
                  </div>
                ))}
              </div>
            </CardContent>
          </Card>
        </TabsContent>

        {/* Bookings Tab */}
        <TabsContent value="bookings">
          <Card className="bg-white/30 backdrop-blur-sm border-2 border-[#B98E57]/30 shadow-xl">
            <CardHeader>
              <CardTitle className="text-2xl font-serif text-[#5E4022] flex items-center space-x-2">
                <span>🎫</span>
                <span>My Bookings</span>
              </CardTitle>
              <CardDescription className="text-[#5E4022]/70">
                Your tour reservations and tickets
              </CardDescription>
            </CardHeader>
            <CardContent>
              <div className="space-y-4">
                {bookings.map((booking) => (
                  <div key={booking.id} className="p-4 bg-white/20 rounded-lg border border-[#B98E57]/20 hover:bg-white/30 transition-colors">
                    <div className="flex justify-between items-center">
                      <div>
                        <h3 className="text-lg font-serif text-[#5E4022]">{booking.landmark}</h3>
                        <p className="text-[#5E4022]/70">{booking.date}</p>
                      </div>
                      <span className={`px-3 py-1 rounded-full text-sm font-serif ${
                        booking.status === 'Confirmed' 
                          ? 'bg-green-100 text-green-700 border border-green-200' 
                          : 'bg-yellow-100 text-yellow-700 border border-yellow-200'
                      }`}>
                        {booking.status}
                      </span>
                    </div>
                  </div>
                ))}
              </div>
            </CardContent>
          </Card>
        </TabsContent>
      </Tabs>

      {/* Logout Button */}
      <div className="mt-8 text-center">
        <Button
          variant="outline"
          className="border-red-300 text-red-600 hover:bg-red-50 hover:text-red-700 font-serif"
          onClick={() => {
            // TODO: Implement logout
            console.log("Logout");
          }}
        >
          Leave the Temple 🚪
        </Button>
      </div>
    </div>
  );
};

export default Profile;
