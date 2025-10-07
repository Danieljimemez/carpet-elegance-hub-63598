import Header from "@/components/Header";
import Hero from "@/components/Hero";
import Catalog from "@/components/Catalog";
import Collections from "@/components/Collections";
import About from "@/components/About";
import Testimonials from "@/components/Testimonials";
import WeeklyUpdates from "@/components/WeeklyUpdates";
import Contact from "@/components/Contact";
import Footer from "@/components/Footer";

const Index = () => {
  return (
    <div className="min-h-screen font-sans">
      <Header />
      <main>
        <Hero />
        <Catalog />
        <Collections />
        <About />
        <Testimonials />
        <WeeklyUpdates />
        <Contact />
      </main>
      <Footer />
    </div>
  );
};

export default Index;
