import 'dart:math';

/// Service for generating and managing project invite slugs
class InviteService {
  static const int _maxSlugLength = 50;
  static const String _randomChars = 'abcdefghijklmnopqrstuvwxyz0123456789';

  /// Generate a URL-friendly slug from project name
  /// Example: "Гамлет в Таганке" -> "hamlet-v-taganke"
  static String generateSlugFromName(String projectName) {
    String slug = projectName
        .toLowerCase()
        .trim()
        // Replace Cyrillic characters with Latin equivalents
        .replaceAll(RegExp(r'[а]'), 'a')
        .replaceAll(RegExp(r'[б]'), 'b')
        .replaceAll(RegExp(r'[в]'), 'v')
        .replaceAll(RegExp(r'[г]'), 'g')
        .replaceAll(RegExp(r'[д]'), 'd')
        .replaceAll(RegExp(r'[е|ё]'), 'e')
        .replaceAll(RegExp(r'[ж]'), 'zh')
        .replaceAll(RegExp(r'[з]'), 'z')
        .replaceAll(RegExp(r'[и|й]'), 'i')
        .replaceAll(RegExp(r'[к]'), 'k')
        .replaceAll(RegExp(r'[л]'), 'l')
        .replaceAll(RegExp(r'[м]'), 'm')
        .replaceAll(RegExp(r'[н]'), 'n')
        .replaceAll(RegExp(r'[о]'), 'o')
        .replaceAll(RegExp(r'[п]'), 'p')
        .replaceAll(RegExp(r'[р]'), 'r')
        .replaceAll(RegExp(r'[с]'), 's')
        .replaceAll(RegExp(r'[т]'), 't')
        .replaceAll(RegExp(r'[у]'), 'u')
        .replaceAll(RegExp(r'[ф]'), 'f')
        .replaceAll(RegExp(r'[х]'), 'h')
        .replaceAll(RegExp(r'[ц]'), 'ts')
        .replaceAll(RegExp(r'[ч]'), 'ch')
        .replaceAll(RegExp(r'[ш]'), 'sh')
        .replaceAll(RegExp(r'[щ]'), 'sch')
        .replaceAll(RegExp(r'[ъ|ь]'), '')
        .replaceAll(RegExp(r'[ы]'), 'y')
        .replaceAll(RegExp(r'[э]'), 'e')
        .replaceAll(RegExp(r'[ю]'), 'yu')
        .replaceAll(RegExp(r'[я]'), 'ya')
        // Replace spaces and special characters with hyphens
        .replaceAll(RegExp(r'[\s\-_\.]+'), '-')
        // Remove any remaining non-alphanumeric characters except hyphens
        .replaceAll(RegExp(r'[^a-z0-9\-]'), '')
        // Remove multiple consecutive hyphens
        .replaceAll(RegExp(r'-+'), '-')
        // Remove leading/trailing hyphens
        .replaceAll(RegExp(r'^-|-$'), '');

    // Ensure slug is not empty
    if (slug.isEmpty) {
      slug = 'project';
    }

    // Truncate if too long
    if (slug.length > _maxSlugLength) {
      slug = slug.substring(0, _maxSlugLength);
      // Remove trailing hyphen if truncation caused it
      slug = slug.replaceAll(RegExp(r'-$'), '');
    }

    return slug;
  }

  /// Generate a unique slug with optional suffix for conflict resolution
  /// Example: "hamlet" -> "hamlet-2024" or "hamlet-abc123"
  static String generateUniqueSlug(String projectName, {String? suffix}) {
    String baseSlug = generateSlugFromName(projectName);

    if (suffix != null) {
      String finalSlug = '$baseSlug-$suffix';
      // Ensure final slug doesn't exceed max length
      if (finalSlug.length > _maxSlugLength) {
        int availableLength =
            _maxSlugLength - suffix.length - 1; // -1 for hyphen
        if (availableLength > 0) {
          baseSlug = baseSlug.substring(0, availableLength);
          finalSlug = '$baseSlug-$suffix';
        } else {
          // If suffix is too long, just use it
          finalSlug = suffix.substring(0, _maxSlugLength);
        }
      }
      return finalSlug;
    }

    return baseSlug;
  }

  /// Generate a fallback random slug when name-based slug conflicts
  /// Returns slug like "project-abc123" or just "abc123" if base is too long
  static String generateRandomSlug({String base = 'project'}) {
    const int randomLength = 6;
    final random = Random();
    final randomSuffix = List.generate(
      randomLength,
      (index) => _randomChars[random.nextInt(_randomChars.length)],
    ).join();

    String slug = base.isNotEmpty ? '$base-$randomSuffix' : randomSuffix;

    // Ensure slug doesn't exceed max length
    if (slug.length > _maxSlugLength) {
      slug = randomSuffix;
    }

    return slug;
  }

  /// Validate if slug contains only allowed characters
  static bool isValidSlug(String slug) {
    if (slug.isEmpty || slug.length > _maxSlugLength) {
      return false;
    }

    // Check format: lowercase letters, numbers, hyphens
    // Cannot start or end with hyphen
    final slugRegex = RegExp(r'^[a-z0-9]+([a-z0-9\-]*[a-z0-9]+)?$');
    return slugRegex.hasMatch(slug);
  }

  /// Generate app URL for invite slug
  /// For development: http://localhost:3020/#/join/hamlet
  /// For production: https://rehearsal.app/join/hamlet
  static String generateInviteUrl(String slug, {String? baseUrl}) {
    // Auto-detect environment if baseUrl not provided
    baseUrl ??= _detectBaseUrl();

    return '$baseUrl/#/join/$slug';
  }

  /// Auto-detect base URL based on environment
  static String _detectBaseUrl() {
    // In Flutter web, we can check current URL
    // For development, this would be localhost
    // For now, return development URL
    return 'http://localhost:3020';
  }
}
