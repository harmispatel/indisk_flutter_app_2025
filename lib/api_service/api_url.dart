String BASE_URL = "https://indisk-app.harmistechnology.com/api/";
// String BASE_URL = "https://indisk.harmistechnology.com/api/";

class ApiUrl {
  static String LOGIN = "${BASE_URL}login";
  static String CREATE_MANAGER = "${BASE_URL}staff/staff-create";
  static String UPDATE_MANAGER = "${BASE_URL}staff/staff-update";
  static String DELETE_STAFF = "${BASE_URL}staff/staff-delete";
  static String GET_STAFF_LIST = "${BASE_URL}manager/staff-list";
  static String CREATE_FOOD_CATEGORY = "${BASE_URL}create-food-category";
  static String UPDATE_FOOD_CATEGORY = "${BASE_URL}update-food-category";
  static String DELETE_FOOD_CATEGORY = "${BASE_URL}delete-food-category";
  static String GET_FOOD_CATEGORY_LIST = "${BASE_URL}food-category-list";

  static String CREATE_FOOD = "${BASE_URL}create-food";
  static String UPDATE_FOOD = "${BASE_URL}update-food";
  static String DELETE_FOOD = "${BASE_URL}delete-food";
  static String GET_FOOD = "${BASE_URL}get-food-list";
  static String RESTAURANT_CREATE = "${BASE_URL}restaurant-create";
  static String RESTAURANT_LIST = "${BASE_URL}restaurant-list";
  static String DELETE_RESTAURANT = "${BASE_URL}restaurant-delete";
  static String GET_OWNER_HOME = "${BASE_URL}get-owner-home";
  static String EDIT_RESTAURANT = "${BASE_URL}restaurant-update";
  static String CHANGE_PASSWORD = "${BASE_URL}change-password";
  static String GET_PROFILE = "${BASE_URL}get-profile";
  static String EDIT_PROFILE = "${BASE_URL}edit-profile";
  static String GET_RESTAURANT_DETAILS = "${BASE_URL}get-restaurant-details";
  static String ADD_TO_CART = "${BASE_URL}add-to-cart";
  static String GET_CART = "${BASE_URL}get-cart";
  static String UPDATE_QUANTITY = "${BASE_URL}update-quantity";
  static String CLEAR_CART = "${BASE_URL}clear-cart";
  static String REMOVE_TO_CART = "${BASE_URL}remove-to-cart";
}
