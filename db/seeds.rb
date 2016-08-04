# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

User.create(name: 'admin', email: 'admin@ripple-tech.com', password: '11111111') if User.find_by_email('admin@ripple-tech.com').nil?

ActiveRecord::Base.connection.execute(
	"

	INSERT INTO `dicts` (`id`, `category`, `code`, `title`) VALUES
	(196, 'region', '10', 'PRC'),
	(200, 'region', '20', 'USA'),
	(202, 'region', '30', 'Europe'),
	(209, 'GMU', '021', 'Shanghai'),
	(210, 'GMU', '010', 'Beijing'),
	(239, 'PFA_reason', '9', 'Value'),
	(240, 'PFA_reason', '8', 'Pricing'),
	(241, 'PFA_reason', '7', 'Resourcing'),
	(242, 'UFA_reason', 'A', 'Value'),
	(243, 'UFA_reason', 'B', 'Pricing'),
	(244, 'UFA_reason', 'C', 'Resourcing'),
	(245, 'UFA_reason', 'D', 'Scope'),
	(246, 'UFA_reason', 'E', 'Execution'),
	(247, 'risk', '1', 'High'),
	(248, 'risk', '2', 'Medium+'),
	(249, 'risk', '3', 'Medium'),
	(250, 'risk', '4', 'Medium-'),
	(251, 'prj_status', '1', 'Active'),
	(252, 'prj_status', '0', 'closed'),
	(253, 'gender', '0', 'Male'),
	(254, 'gender', '1', 'Female'),
	(257, 'billing_status', '1', 'Y'),
	(258, 'billing_status', '0', 'N'),
	(259, 'person_status', '0', 'On leave'),
	(260, 'person_status', '1', 'Resigned'),
	(261, 'client_category', '00', 'FIE'),
	(262, 'client_category', '01', 'SOE'),
	(263, 'client_category', '02', 'Domestic private'),
	(264, 'client_category', '03', 'Overseas listed'),
	(265, 'client_category', '04', 'Domestic listed'),
	(266, 'client_status', '1', 'Active'),
	(267, 'client_status', '0', 'Inactive'),
	(270, 'revenue_type', '01', 'one-off'),
	(271, 'revenue_type', '02', 'monthly'),
	(272, 'revenue_type', '03', 'quarterly'),
	(273, 'revenue_type', '04', 'recurring'),
	(274, 'PFA_reason', '0', ''),
	(275, 'region', '40', 'Japan/Korea'),
	(276, 'region', '50', 'HongKong/Taiwan'),
	(277, 'region', '60', 'Other'),
	(278, 'department', '01', 'Consulting'),
	(279, 'department', '02', 'Outsourcing'),
	(280, 'department', '03', 'Admin'),
	(281, 'person_status', '2', 'Employed'),
	(282, 'service_code', '10', 'Others not specified'),
	(283, 'service_code', '11', 'Statutory Audit'),
	(284, 'service_code', '12', 'IFRS Audit'),
	(285, 'service_code', '13', 'Capital Verification'),
	(286, 'service_code', '14', 'Foreign Exchange Inspection'),
	(287, 'service_code', '30', 'Others not specified'),
	(288, 'service_code', '31', 'Financial Due Diligence'),
	(289, 'service_code', '32', 'Quarterly Review'),
	(290, 'service_code', '33', 'Limited Review'),
	(291, 'service_code', '34', 'Accounting & Financial Policy design'),
	(292, 'service_code', '35', 'Business Process Improvement'),
	(293, 'service_code', '36', 'Business Process Reengineering'),
	(294, 'service_code', '37', 'Internal Audit'),
	(295, 'service_code', '38', 'SOX404 compliance'),
	(296, 'service_code', '39', 'IPO advisory'),
	(297, 'service_code', '41', 'Management Consulting'),
	(298, 'service_code', '42', 'External Training'),
	(299, 'service_code', '60', 'Others not specified'),
	(300, 'service_code', '61', 'Financial Outsoucing'),
	(301, 'service_code', '62', 'Bookkeeping'),
	(302, 'service_code', '63', 'Tax Compliance'),
	(303, 'service_code', '64', 'Retainer'),
	(304, 'service_code', '65', 'Payroll Processing'),
	(305, 'service_code', '66', 'Payment Processing'),
	(306, 'service_code', '67', 'Company Formation'),
	(307, 'service_code', '80', 'Others nto specified'),
	(309, 'risk', '5', 'Low'),
	(310, 'client_category', '05', 'Individual'),
	(311, 'service_code', '81', 'Professional Staff Support'),
	(313, 'billing_type', '0', 'service'),
	(314, 'billing_type', '1', 'expense'),
	(316, 'billing_number', '0000', '20160714'),
	(317, 'ot_type', '1.5', 'weekday'),
	(318, 'ot_type', '2', 'weekend'),
	(319, 'ot_type', '3', 'hoilday'),
	(320, 'ot_type', '-1', 'OT leave'),
	(321, 'ot_type', '-1', 'paid_hours'),
	(322, 'expense_log', '1', '2009-05-01'),
	(323, 'expense_log', '1', '2009-05-16'),
	(324, 'expense_log', '1', '2009-06-01'),
	(325, 'expense_log', '1', '2009-06-15'),
	(326, 'expense_log', '1', '2009-07-01'),
	(327, 'expense_log', '1', '2009-07-16'),
	(328, 'expense_log', '1', '2009-08-01'),
	(329, 'expense_log', '1', '2009-08-16'),
	(330, 'expense_log', '1', '2009-09-01'),
	(331, 'expense_log', '1', '2009-09-16'),
	(332, 'expense_log', '1', '2009-10-01'),
	(333, 'expense_log', '1', '2009-10-16'),
	(334, 'expense_log', '1', '2009-11-01'),
	(335, 'expense_log', '1', '2009-11-16'),
	(336, 'expense_log', '1', '2009-12-01'),
	(337, 'expense_log', '1', '2009-12-16'),
	(338, 'expense_log', '1', '2010-01-01'),
	(339, 'expense_log', '1', '2010-01-16'),
	(340, 'expense_log', '1', '2010-02-01'),
	(341, 'expense_log', '1', '2010-02-16'),
	(342, 'expense_log', '1', '2010-3-01'),
	(343, 'expense_log', '1', '2010-3-16'),
	(344, 'expense_log', '1', '2010-04-01'),
	(345, 'expense_log', '1', '2010-4-16'),
	(346, 'expense_log', '1', '2010-05-01'),
	(347, 'expense_log', '1', '2010-05-16'),
	(348, 'expense_log', '1', '2010-06-01'),
	(349, 'expense_log', '1', '2010-06-16'),
	(350, 'expense_log', '1', '2010-07-01'),
	(351, 'expense_log', '1', '2010-07-16'),
	(352, 'expense_log', '1', '2010-08-01'),
	(353, 'expense_log', '1', '2010-08-16'),
	(354, 'expense_log', '1', '2010-09-01'),
	(355, 'expense_log', '1', '2010-09-16'),
	(356, 'expense_log', '1', '2010-10-01'),
	(357, 'expense_log', '1', '2010-10-16'),
	(358, 'expense_log', '1', '2010-11-01'),
	(359, 'expense_log', '1', '2010-11-16'),
	(360, 'expense_log', '1', '2010-12-01'),
	(361, 'expense_log', '1', '2010-12-16'),
	(362, 'expense_log', '1', '2011-01-01'),
	(363, 'expense_log', '1', '2011-01-16'),
	(364, 'expense_log', '1', '2011-02-01'),
	(365, 'expense_log', '1', '2011-02-16'),
	(366, 'expense_log', '1', '2011-03-01'),
	(367, 'service_code', '51', 'Tax compliance - Corporate'),
	(368, 'service_code', '52', 'Tax compliance - Individual'),
	(369, 'service_code', '53', 'Tax Advisory - Corporate'),
	(370, 'service_code', '54', 'Tax Advisory - Individual'),
	(371, 'service_code', '55', 'Tax Advisory - Investment'),
	(372, 'service_code', '56', 'Tax Advisory - Transaction'),
	(373, 'service_code', '57', 'Tax Advisory - Investigation & audit'),
	(374, 'service_code', '58', 'Tax Advisory - Transfer Pricing'),
	(375, 'service_code', '59', 'Tax provision review'),
	(376, 'service_code', '50', 'Other tax services'),
	(377, 'expense_log', '1', '2011-03-16'),
	(378, 'expense_log', '1', '2011-04-01'),
	(379, 'expense_log', '1', '2011-04-16'),
	(380, 'expense_log', '1', '2011-05-01'),
	(381, 'expense_log', '1', '2011-05-16'),
	(382, 'expense_log', '1', '2011-06-01'),
	(383, 'expense_log', '1', '2011-12-01'),
	(384, 'expense_log', '1', '2011-12-16'),
	(385, 'expense_log', '1', '2012－01－01'),
	(386, 'expense_log', '1', '2012-01-01'),
	(387, 'expense_log', '1', '2012-01-16'),
	(388, 'expense_log', '1', '2012-02-01'),
	(389, 'expense_log', '1', '2012-02-16'),
	(390, 'expense_log', '1', '2012-03-01'),
	(391, 'expense_log', '1', '2012-03-16'),
	(392, 'expense_log', '1', '2012-04-01'),
	(393, 'expense_log', '1', '2012-04-16'),
	(394, 'expense_log', '1', '2012-05-01'),
	(395, 'expense_log', '1', '2012-05-16'),
	(396, 'expense_log', '1', '2012-06-01'),
	(397, 'expense_log', '1', '2012-06-16'),
	(398, 'expense_log', '1', '2012-07-01'),
	(399, 'expense_log', '1', '2012-07-16'),
	(400, 'expense_log', '1', '2012-08-01'),
	(401, 'expense_log', '1', '2012-08-16'),
	(402, 'expense_log', '1', '2012-09-01'),
	(403, 'expense_log', '1', '2012-09-16'),
	(404, 'expense_log', '1', '2012-10-01'),
	(405, 'expense_log', '1', '2012-10-16'),
	(406, 'expense_log', '1', '2012-11-01'),
	(407, 'expense_log', '1', '2012-11-16'),
	(408, 'expense_log', '1', '2012-12-01'),
	(409, 'expense_log', '1', '2012-12-16'),
	(410, 'expense_log', '1', '2013-01-01'),
	(411, 'expense_log', '1', '2013-01-16'),
	(412, 'expense_log', '1', '2013-02-01'),
	(413, 'expense_log', '1', '2013-02-16'),
	(414, 'expense_log', '1', '2013-03-01'),
	(415, 'expense_log', '1', '2013-03-16'),
	(416, 'expense_log', '1', '2013-04-01'),
	(417, 'expense_log', '1', '2013-04-16'),
	(418, 'expense_log', '1', '2013-05-01'),
	(419, 'expense_log', '1', '2013-05-16'),
	(420, 'expense_log', '1', '2013-06-01'),
	(421, 'expense_log', '1', '2013-06-16'),
	(422, 'expense_log', '1', '2013-07-01'),
	(423, 'expense_log', '1', '2013-07-16'),
	(424, 'expense_log', '1', '2013-08-01'),
	(425, 'expense_log', '1', '2013-08-16'),
	(426, 'expense_log', '1', '3012-09-01'),
	(427, 'expense_log', '1', '2013-09-01'),
	(428, 'expense_log', '1', '2013-09-16'),
	(429, 'expense_log', '1', '2013-10-01'),
	(430, 'expense_log', '1', '2013-10-16'),
	(431, 'expense_log', '1', '2013-11-01'),
	(432, 'expense_log', '1', '2013-11-16'),
	(433, 'expense_log', '1', '2013-12-01'),
	(434, 'expense_log', '1', '2013-12-16'),
	(435, 'expense_log', '1', '2014-01-01'),
	(436, 'expense_log', '1', '2014-01-16'),
	(437, 'expense_log', '1', '2014-02-01'),
	(438, 'expense_log', '1', '2014-02-16'),
	(439, 'expense_log', '1', '2014-03-01'),
	(440, 'expense_log', '1', '2014-03-16'),
	(441, 'expense_log', '1', '2014-04-01'),
	(442, 'expense_log', '1', '2014-04-16'),
	(443, 'expense_log', '1', '2014-05-01'),
	(444, 'expense_log', '1', '2014-05-16'),
	(445, 'expense_log', '1', '2014-06-01'),
	(446, 'expense_log', '1', '2014-06-16'),
	(447, 'expense_log', '1', '2014-07-01'),
	(448, 'expense_log', '1', '2014-07-16'),
	(449, 'expense_log', '1', '2014-08-01'),
	(450, 'expense_log', '1', '2014-08-16'),
	(451, 'expense_log', '1', '2014-09-01'),
	(452, 'expense_log', '1', '2014-09-16'),
	(453, 'expense_log', '1', '2014-10-01'),
	(454, 'expense_log', '1', '2014-10-16'),
	(455, 'expense_log', '1', '2014-11-01'),
	(456, 'expense_log', '1', '2014-11-16'),
	(457, 'expense_log', '1', '2014-12-01'),
	(458, 'expense_log', '1', '2014-12-16'),
	(459, 'expense_log', '1', '2015-01-01'),
	(460, 'expense_log', '1', '2015-01-16'),
	(461, 'expense_log', '1', '2015-02-16'),
	(462, 'expense_log', '1', '2015-03-01'),
	(463, 'expense_log', '1', '2015-03-16'),
	(464, 'expense_log', '1', '2015-04-01'),
	(465, 'expense_log', '1', '2015-04-16'),
	(466, 'expense_log', '1', '2015-05-01'),
	(467, 'expense_log', '1', '2015-05-16'),
	(468, 'expense_log', '1', '2015-06-01'),
	(469, 'expense_log', '1', '2015-06-16'),
	(470, 'expense_log', '1', '2015-07-01'),
	(471, 'expense_log', '1', '2015-07-16'),
	(472, 'expense_log', '1', '2015-08-01'),
	(473, 'expense_log', '1', '2015-08-16');
	"
	)

ActiveRecord::Base.connection.execute(
	"
		INSERT INTO `industries` (`id`, `code`, `title`) VALUES
		(1, 'A11', 'Technology-Software'),
		(2, 'A12', 'Technology-Hardware'),
		(3, 'A14', 'Technology-Life Science'),
		(4, 'A15', 'Technology-Other'),
		(5, 'A20', 'Transportation Equipment'),
		(6, 'A30', 'Bacic Materials-No Detailed Industry'),
		(7, 'A31', 'Basic Materials-Chemicals'),
		(8, 'A32', 'Basic Materials-Metals'),
		(9, 'A33', 'Basic Materials-Rubber and Plastics'),
		(10, 'A34', 'Basic Materials-Stone,Glass and Clay'),
		(11, 'A35', 'Basic Materials-Paper,Lumber and Forestry'),
		(12, 'A36', 'Basic Materials-Textiles and Apparel'),
		(13, 'A50', 'Fabricated Products'),
		(14, 'A60', 'Industrial Construction'),
		(15, 'A90', 'Manufacturing-Others'),
		(16, 'B10', 'Food and Beverage Processing and Distribution'),
		(17, 'B20', 'Pharmaceuticals'),
		(18, 'B30', 'Retail-No Detailed Industry'),
		(19, 'B31', 'Retail-Food Stores'),
		(20, 'B32', 'Retail-General Merchandise Stores'),
		(21, 'B33', 'Retail-Apparel and Accessory Stores'),
		(22, 'B34', 'Retail-Services'),
		(23, 'B40', 'Wholesale Distribution'),
		(24, 'B70', 'Transportation Services-No Detailed'),
		(25, 'B71', 'Transportation Services-Airlines'),
		(26, 'B72', 'Transportation Services-Railroads'),
		(27, 'B73', 'Transportation-Shipping,Trucking and Buses'),
		(28, 'C50', 'Health Care And Environmental Services'),
		(29, 'C51', 'ThinkBridge'),
		(30, 'C60', 'Environmental'),
		(31, 'D11', 'Oil and Gas-Exploration and Production'),
		(32, 'D12', 'Oil and Gas-Refinery'),
		(33, 'D18', 'Oil and Gas-Petrochemicals'),
		(34, 'D20', 'Mining'),
		(35, 'D30', 'Utilities-No Detailed Industery'),
		(36, 'D31', 'Utilities-Electric'),
		(37, 'D32', 'Utilities-Natural Gas'),
		(38, 'D33', 'Utilities-Electric and Gas Combination'),
		(39, 'D34', 'Utilities-Water and Sewer'),
		(40, 'D35', 'Utilities-Independent Power Proucers'),
		(41, 'E10', 'Banking And S and l'),
		(42, 'E20', 'Finance Companies'),
		(43, 'E30', 'Leasing'),
		(44, 'E40', 'Mortgage Bankers'),
		(45, 'E50', 'Asset Management'),
		(46, 'E60', 'Futures/Commodities'),
		(47, 'E70', 'Stockberokerage and Investment Banking'),
		(48, 'E80', 'Universal Banks'),
		(49, 'F10', 'Life and Health'),
		(50, 'F20', 'Property and Casualty'),
		(51, 'F40', 'Agents And Brokers'),
		(52, 'F50', 'Employee Benefits'),
		(53, 'F60', 'Regulatory Agencies/Bodies'),
		(54, 'G20', 'Hospitality'),
		(55, 'G22', 'Hotrls and motels'),
		(56, 'G27', 'Resorts/Golf Clubs'),
		(57, 'G30', 'Real Estate'),
		(58, 'G33', 'Developers'),
		(59, 'G34', 'Owners and Oferators'),
		(60, 'G35', 'Managers and Oferators'),
		(61, 'G40', 'Construction'),
		(62, 'HA0', 'Pharmaceuticals'),
		(63, 'H10', 'Hpspitals/Health Systems'),
		(64, 'H20', 'Long Term Care Facilities'),
		(65, 'H30', 'Physician Practices And Cliics/Ambulatory/Outpatient Care'),
		(66, 'H50', 'Other Providers'),
		(67, 'H60', 'Physician/Hospital and Medical Service Organisation,Medical Association'),
		(68, 'I10', 'Desense'),
		(69, 'I40', 'International Lending Agencise'),
		(70, 'I60', 'Civilian'),
		(71, 'I61', 'Government Agencies'),
		(72, 'I64', 'Education'),
		(73, 'J30', 'Technology'),
		(74, 'J31', 'Technology-Software'),
		(75, 'J32', 'Technology-Hardware'),
		(76, 'J33', 'Technology-Life Science'),
		(77, 'J34', 'Technology-Netwrng and Comm'),
		(78, 'J40', 'Telecom'),
		(79, 'J41', 'Telecom-Wireline Telecom'),
		(80, 'J42', 'Telecom-Wireless Telecom'),
		(81, 'J43', 'Telecom-Internet Service'),
		(82, 'J45', 'Telecom-Telecom Equipment'),
		(83, 'J50', 'Entertainment Distribution'),
		(84, 'J54', 'Sports'),
		(85, 'J60', 'Media'),
		(86, 'J61', 'Media-Publishing'),
		(87, 'J62', 'Media-Printing'),
		(88, 'J63', 'Media-Information Services'),
		(89, 'J64', 'Media-Advertising'),
		(90, 'U10', 'Individual Use'),
		(91, 'U20', 'Private Trusts'),
		(92, 'U30', 'Non Profit'),
		(93, 'U90', 'Unspecified'),
		(94, 'G27', 'resorts/golf clubs'),
		(95, 'G33', 'developers'),
		(96, 'I64', 'education'),
		(97, 'J54', 'sports');
	"
)