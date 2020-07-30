set(CHAPTER00 "${PROJECT_NAME}.chapter.02")

add_executable(${CHAPTER00})

target_compile_options(${CHAPTER00} PRIVATE
    -std=c++2a -Wall -pedantic -Wextra -Weffc++ -fconcepts)

target_sources(${CHAPTER00} PRIVATE
    main.cc)
