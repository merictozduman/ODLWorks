CREATE OR REPLACE PACKAGE PKG_EMAIL_PROCESS AS
  PROCEDURE PRC_EMAIL_STEP2(
                            vEmail IN VARCHAR2, 
 							in_email OUT VARCHAR2);
  PROCEDURE PRC_EMAIL_STEP3_1(
   							vEmailStep2 IN VARCHAR2, 
 							var_email_lower OUT VARCHAR2, 
 							var_domain_lower OUT VARCHAR2, 
 							var_email_reverse OUT VARCHAR2);
  PROCEDURE PRC_EMAIL_STEP3_2(
  							 var_email_lower IN VARCHAR2, 
  							 var_domain_lower IN VARCHAR2, 
  							 var_email_reverse IN VARCHAR2,
                             exp_undefined_character OUT VARCHAR2, 
                             exp_email_subdomain OUT VARCHAR2,
                             exp_email_lower OUT VARCHAR2, 
                             exp_email_user_name OUT VARCHAR2);
  PROCEDURE PRC_EMAIL_STEP4(
  							exp_email_subdomain IN VARCHAR2, 
  							exp_email_user_name IN VARCHAR2, 
  							exp_email_lower IN VARCHAR2,
                            Tkn_subdomain_pattern OUT VARCHAR2, 
                            TokenizedData2 OUT VARCHAR2,
                            Tkn_username_noise OUT VARCHAR2, 
                            tokenizedData5 OUT VARCHAR2,
                            std_email_without_symbol OUT VARCHAR2);
  PROCEDURE PRC_EMAIL_STEP5_1(
  							  vEmail IN VARCHAR2, 
 							  var_email_character_first_order OUT NUMBER);
  PROCEDURE PRC_EMAIL_STEP5_2(
  							 exp_undefined_character IN VARCHAR2, 
  							 std_email_without_symbol IN VARCHAR2, 
  							 in_email IN VARCHAR2,
                             var_email_character_first_order IN NUMBER, 
                             exp_undefined_character_length OUT NUMBER,
                             exp_email_without_symbol_length OUT NUMBER, 
                             exp_email_user_name OUT number,
                             exp_email_character_first_order OUT NUMBER);
   PROCEDURE CHECK_EMAIL_QUALITY(
						    in_email IN VARCHAR2,
						    exp_undefined_character_length IN NUMBER,
						    exp_email_without_symbol_length IN NUMBER,
						    exp_email_user_name IN number,
						    exp_email_character_first_order IN NUMBER,
						    tkn_username_noise IN VARCHAR2,
						    tkn_subdomain_pattern IN VARCHAR2,
						    dec_email_quality_detail_code OUT VARCHAR2,
						    dec_cl_email OUT VARCHAR2
							);
   PROCEDURE MAIN_EMAIL_PROCESS(
						    vEmail IN VARCHAR2,
						    dec_email_quality_detail_code OUT VARCHAR2,
						    dec_cl_email OUT VARCHAR2
						    );					
END PKG_EMAIL_PROCESS;