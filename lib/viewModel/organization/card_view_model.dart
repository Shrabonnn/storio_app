import 'package:flutter/foundation.dart';

import '../../data/model/organization/card/card_model.dart';
import '../../data/repository/organization/card_repository.dart';

class CardViewModel extends ChangeNotifier {
  final CardRepository _repository = CardRepository();

  // ============================================================
  // VARIABLES
  // ============================================================

  List<CardModel> _cards = [];

  List<CardModel> get cards => _cards;

  CardModel? _selectedCard;

  CardModel? get selectedCard => _selectedCard;

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  bool _isSaving = false;

  bool get isSaving => _isSaving;

  bool _isDeleting = false;

  bool get isDeleting => _isDeleting;

  bool _isReordering = false;

  bool get isReordering => _isReordering;

  String? _errorMessage;

  String? get errorMessage => _errorMessage;

  // ============================================================
  // SET LOADING
  // ============================================================

  void _setError(String? message) {
    _errorMessage = message;
    notifyListeners();
  }

  // ============================================================
  // GET ALL CARDS
  // ============================================================

  Future<bool> getCardsApi() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final result = await _repository.getCardsApi();

      _cards = result;

      return true;
    } catch (e) {
      _errorMessage = e.toString();

      debugPrint('GET CARDS ERROR: $e');

      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // ============================================================
  // GET CARD DETAIL
  // ============================================================

  Future<bool> getCardByIdApi(int id) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final result = await _repository.getCardByIdApi(id);

      _selectedCard = result;

      return true;
    } catch (e) {
      _errorMessage = e.toString();

      debugPrint('GET CARD DETAIL ERROR: $e');

      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // ============================================================
  // CREATE CARD
  // ============================================================

  Future<bool> createCardApi(
      Map<String, dynamic> data,
      ) async {
    _isSaving = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final result = await _repository.createCardApi(data);

      _cards.add(result);

      return true;
    } catch (e) {
      _errorMessage = e.toString();

      debugPrint('CREATE CARD ERROR: $e');

      return false;
    } finally {
      _isSaving = false;
      notifyListeners();
    }
  }

  // ============================================================
  // UPDATE CARD - PUT
  // ============================================================

  Future<bool> updateCardApi(
      int id,
      Map<String, dynamic> data,
      ) async {
    _isSaving = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final result = await _repository.updateCardApi(
        id,
        data,
      );

      final index = _cards.indexWhere(
            (card) => card.id == id,
      );

      if (index != -1) {
        _cards[index] = result;
      }

      _selectedCard = result;

      return true;
    } catch (e) {
      _errorMessage = e.toString();

      debugPrint('UPDATE CARD ERROR: $e');

      return false;
    } finally {
      _isSaving = false;
      notifyListeners();
    }
  }

  // ============================================================
  // PATCH CARD
  // ============================================================

  Future<bool> patchCardApi(
      int id,
      Map<String, dynamic> data,
      ) async {
    _isSaving = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final result = await _repository.patchCardApi(
        id,
        data,
      );

      final index = _cards.indexWhere(
            (card) => card.id == id,
      );

      if (index != -1) {
        _cards[index] = result;
      }

      _selectedCard = result;

      return true;
    } catch (e) {
      _errorMessage = e.toString();

      debugPrint('PATCH CARD ERROR: $e');

      return false;
    } finally {
      _isSaving = false;
      notifyListeners();
    }
  }

  // ============================================================
  // DELETE CARD
  // ============================================================

  Future<bool> deleteCardApi(int id) async {
    _isDeleting = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _repository.deleteCardApi(id);

      _cards.removeWhere(
            (card) => card.id == id,
      );

      if (_selectedCard?.id == id) {
        _selectedCard = null;
      }

      return true;
    } catch (e) {
      _errorMessage = e.toString();

      debugPrint('DELETE CARD ERROR: $e');

      return false;
    } finally {
      _isDeleting = false;
      notifyListeners();
    }
  }

  // ============================================================
  // REORDER CARDS
  // ============================================================

  Future<bool> reorderCardsApi(
      List<int> ids,
      ) async {
    _isReordering = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _repository.reorderCardsApi(ids);

      // Update local order according to the new list
      for (int i = 0; i < ids.length; i++) {
        final index = _cards.indexWhere(
              (card) => card.id == ids[i],
        );

        if (index != -1) {
          _cards[index].order = i;
        }
      }

      // Keep list sorted according to order
      _cards.sort(
            (a, b) => (a.order ?? 0).compareTo(
          b.order ?? 0,
        ),
      );

      return true;
    } catch (e) {
      _errorMessage = e.toString();

      debugPrint('REORDER CARDS ERROR: $e');

      return false;
    } finally {
      _isReordering = false;
      notifyListeners();
    }
  }

  // ============================================================
  // CLEAR SELECTED CARD
  // ============================================================

  void clearSelectedCard() {
    _selectedCard = null;
    notifyListeners();
  }

  // ============================================================
  // CLEAR ERROR
  // ============================================================

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}