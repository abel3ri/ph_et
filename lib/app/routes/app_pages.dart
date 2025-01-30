import 'package:get/get.dart';
import 'package:pharma_et/app/modules/products/bindings/products_binding.dart';
import 'package:pharma_et/app/modules/products/views/products_view.dart';
import 'package:pharma_et/app/modules/sub_category/bindings/sub_category_binding.dart';
import 'package:pharma_et/app/modules/sub_category/views/sub_category_view.dart';

import '../modules/auth/forgot_password/bindings/forgot_password_binding.dart';
import '../modules/auth/forgot_password/views/forgot_password_view.dart';
import '../modules/auth/login/bindings/login_binding.dart';
import '../modules/auth/login/views/login_view.dart';
import '../modules/auth/otp_verification/bindings/otp_verification_binding.dart';
import '../modules/auth/otp_verification/views/otp_verification_view.dart';
import '../modules/auth/signup/bindings/signup_binding.dart';
import '../modules/auth/signup/views/signup_view.dart';
import '../modules/cart/bindings/cart_binding.dart';
import '../modules/cart/bindings/checkout_binding.dart';
import '../modules/cart/views/cart_view.dart';
import '../modules/cart/views/checkout_view.dart';
import '../modules/consultation/bindings/consultation_binding.dart';
import '../modules/consultation/views/consultation_view.dart';
import '../modules/get_started/bindings/get_started_binding.dart';
import '../modules/get_started/views/get_started_view.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/home_wrapper/bindings/home_wrapper_binding.dart';
import '../modules/home_wrapper/views/home_wrapper_view.dart';
import '../modules/image_picker/bindings/image_picker_binding.dart';
import '../modules/image_picker/views/image_picker_view.dart';
import '../modules/image_preview/views/image_preview_view.dart';
import '../modules/order/bindings/order_binding.dart';
import '../modules/order/views/order_view.dart';
import '../modules/policies_and_support/bindings/policies_and_support_binding.dart';
import '../modules/policies_and_support/views/help_and_support_view.dart';
import '../modules/policies_and_support/views/policies_and_support_view.dart';
import '../modules/policies_and_support/views/privacy_policy_view.dart';
import '../modules/policies_and_support/views/terms_and_conditions_view.dart';
import '../modules/product_details/bindings/product_details_binding.dart';
import '../modules/product_details/bindings/review_form_binding.dart';
import '../modules/product_details/views/product_details_view.dart';
import '../modules/product_details/views/review_form_view.dart';
import '../modules/profile/bindings/edit_profile_binding.dart';
import '../modules/profile/bindings/profile_binding.dart';
import '../modules/profile/views/change_language.dart';
import '../modules/profile/views/edit_profile_view.dart';
import '../modules/profile/views/profile_view.dart';
import '../modules/search/bindings/search_binding.dart';
import '../modules/search/views/search_view.dart';
import '../modules/splash/bindings/splash_binding.dart';
import '../modules/splash/views/splash_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.SPLASH;

  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () => const HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.LOGIN,
      page: () => const LoginView(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: _Paths.SIGNUP,
      page: () => const SignupView(),
      binding: SignupBinding(),
    ),
    GetPage(
      name: _Paths.OTP_VERIFICATION,
      page: () => const OtpVerificationView(),
      binding: OtpVerificationBinding(),
    ),
    GetPage(
      name: _Paths.FORGOT_PASSWORD,
      page: () => const ForgotPasswordView(),
      binding: ForgotPasswordBinding(),
      transition: Transition.downToUp,
      fullscreenDialog: true,
    ),
    GetPage(
      name: _Paths.PROFILE,
      page: () => const ProfileView(),
      binding: ProfileBinding(),
      children: [
        GetPage(
          name: _Paths.CHANGE_LANGUAGE,
          page: () => const ChangeLanguageView(),
        ),
        GetPage(
          name: _Paths.EDIT_PROFILE,
          page: () => const EditProfileView(),
          binding: EditProfileBinding(),
        ),
      ],
    ),
    GetPage(
      name: _Paths.SEARCH,
      page: () => const SearchView(),
      binding: SearchBinding(),
    ),
    GetPage(
      name: _Paths.GET_STARTED,
      page: () => const GetStartedView(),
      binding: GetStartedBinding(),
    ),
    GetPage(
      name: _Paths.SPLASH,
      page: () => const SplashView(),
      binding: SplashBinding(),
    ),
    GetPage(
      name: _Paths.IMAGE_PICKER,
      page: () => const ImagePickerView(),
      binding: ImagePickerBinding(),
    ),
    GetPage(
      name: _Paths.HOME_WRAPPER,
      page: () => const HomeWrapperView(),
      bindings: [
        HomeWrapperBinding(),
        HomeBinding(),
        SearchBinding(),
        CartBinding(),
        OrderBinding(),
        ProfileBinding(),
      ],
    ),
    GetPage(
      name: _Paths.SUB_CATEGORY,
      page: () => const SubCategoryView(),
      binding: SubCategoryBinding(),
    ),
    GetPage(
      name: _Paths.PRODUCTS,
      page: () => const ProductsView(),
      binding: ProductsBinding(),
    ),
    GetPage(
      name: _Paths.CART,
      page: () => const CartView(),
      binding: CartBinding(),
      children: [
        GetPage(
          name: _Paths.CHECKOUT,
          page: () => const CheckoutView(),
          binding: CheckoutBinding(),
        ),
      ],
    ),
    GetPage(
      name: _Paths.POLICIES_AND_SUPPORT,
      page: () => const PoliciesAndSupportView(),
      binding: PoliciesAndSupportBinding(),
      children: [
        GetPage(
          name: _Paths.HELP_AND_SUPPORT,
          page: () => const HelpAndSupportView(),
        ),
        GetPage(
          name: _Paths.TERMS_AND_CONDITIONS,
          page: () => const TermsAndConditionsView(),
        ),
        GetPage(
          name: _Paths.PRIVACY_POLICY,
          page: () => const PrivacyPolicyView(),
        ),
      ],
    ),
    GetPage(
      name: _Paths.PRODUCT_DETAILS,
      page: () => const ProductDetailsView(),
      binding: ProductDetailsBinding(),
      children: [
        GetPage(
          name: _Paths.REVIEW_FORM,
          page: () => const ReviewFormView(),
          binding: ReviewFormBinding(),
        ),
      ],
    ),
    GetPage(
      name: _Paths.CONSULTATION,
      page: () => const ConsultationView(),
      binding: ConsultationBinding(),
    ),
    GetPage(
      name: _Paths.ORDER,
      page: () => const OrderView(),
      binding: OrderBinding(),
    ),
    GetPage(
      name: _Paths.IMAGE_PREVIEW,
      page: () => const ImagePreviewView(),
    ),
  ];
}
