class APIData {
  static const domainLink = "https://test.hand-bill.com/";
  static const domainLinkApi = "https://test.hand-bill.com/api/";

  static const secretKey = "5aoIrZjQvSPA2K3po1HeKHZHowNQdTOPrGQ1Ze0";

  //auth
  static const login = domainLinkApi + 'company/login';
  static const register = domainLinkApi + 'company/register';
  static const restPassword = domainLinkApi + 'company/reset';
  static const forgetPassword = domainLinkApi + 'company/forgot-password';
  static const checkVerificationCode = domainLinkApi + 'company/check-code';
  static const getPlans = domainLinkApi + 'company/plans';
  static const chosePlans = domainLinkApi + 'company/update-plan';

  // notifications
  static const getNotificationsData = domainLinkApi + 'notifications';
  static const removeFromNotifications = domainLinkApi + 'notifications/';
  static const markReadNotifications = domainLinkApi + 'notifications/';

  // jobs
  static const getUsersJobs = domainLinkApi + 'company/users-jobs';
  static const getMyJobs = domainLinkApi + 'company/jobs';
  static const addJob = domainLinkApi + 'company/jobs';
  static const removeJob = domainLinkApi + 'company/remove-job';
  static const getJobsCategories = domainLinkApi + 'user/categories-jobs';
  static const getJobsSubCategories =
      domainLinkApi + 'user/sub-categories-jobs';

  // auction
  static const getMyAuctionData = domainLinkApi + 'company/auctions';
  static const addAuction = domainLinkApi + 'company/create-auction';
  static const removeAuction = domainLinkApi + 'company/remove-auction';
  static const closeAuction = domainLinkApi + 'company/update-auction';

  // agent
  static const getAllAgent = domainLinkApi + 'user/agents';

  // offer
  static const getMyOffersData = domainLinkApi + 'company/offers';
  static const addOffer = domainLinkApi + 'company/offers';
  static const removeOffer = domainLinkApi + 'company/remove-offer';

  // assets
  static const getMyAssetData = domainLinkApi + 'company/assets';
  static const addAsset = domainLinkApi + 'company/assets';
  static const removeAsset = domainLinkApi + 'company/remove-asset';

  //
  static const addFinance = domainLinkApi + 'company/addFinance';
  static const getAllFinance = domainLinkApi + 'company/finance';

  // ads
  static const getAdsCoast = domainLinkApi + 'company/costs';
  static const getMyAdsData = domainLinkApi + 'company/ads';
  static const addAds = domainLinkApi + 'company/request-ads';
  static const removeAds = domainLinkApi + 'company/remove-ads';

  // product
  static const getFeaturedProduct = domainLinkApi + 'company/featured-products';
  static const getProductCategories =
      domainLinkApi + 'company/categories-company';
  static const getProductsByCategory =
      domainLinkApi + 'company/products-by-category';
  static const removeFeatureProduct =
      domainLinkApi + 'company/remove-featured-product';
  static const removeProduct = domainLinkApi + 'company/remove-product';
  static const productDetails = domainLinkApi + 'user/products';

  // market
  static const getMarkets = domainLinkApi + 'restaurants';
  static const getMarketDetails = domainLinkApi + 'restaurants';
  static const getMarketCategories = domainLinkApi + 'categories';

  //profile
  static const getCountries = domainLinkApi + 'company/countries';
  static const companyProfile = domainLinkApi + 'company/details-company';
  static const editProfile = domainLinkApi + 'company/update-profile';
  static const addCompanyImages = domainLinkApi + 'company/upload-images';
  static const removeCompanyImages = domainLinkApi + 'company/remove-images';
  static const addCompanyVideo = domainLinkApi + 'company/upload-video';
  static const removeCompanyVideo = domainLinkApi + 'company/remove-video';
  static const addCompanyLogo = domainLinkApi + 'company/upload-logo';
  static const removeCompanyLogo = domainLinkApi + 'company/remove-logo';
  static const changePassword = domainLinkApi + 'company/change-password';

  //help-center
  static const helpCenter = domainLinkApi + 'user/help-center';

}