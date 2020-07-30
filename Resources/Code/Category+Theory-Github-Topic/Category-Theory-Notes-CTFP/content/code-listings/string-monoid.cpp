template<>
std::string mempty<std::string> = { "" };

std::string mappend(std::string s1, std::string s2) {
    return s1 + s2;
}
