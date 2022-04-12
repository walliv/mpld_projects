----------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;
----------------------------------------------------------------------------------
ENTITY FIR_50k_SIM IS
  PORT (
    aclk                                : IN  STD_LOGIC;
    s_axis_data_tvalid                  : IN  STD_LOGIC;
    s_axis_data_tready                  : OUT STD_LOGIC;
    s_axis_data_tdata                   : IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
    m_axis_data_tvalid                  : OUT STD_LOGIC := '0';
    m_axis_data_tdata                   : OUT STD_LOGIC_VECTOR(15 DOWNTO 0) := (OTHERS => '0')
  );
END FIR_50k_SIM;
----------------------------------------------------------------------------------
ARCHITECTURE structural OF FIR_50k_SIM IS
----------------------------------------------------------------------------------

  SIGNAL cnt_fir_out                    : INTEGER := 0;
  SIGNAL cnt_fir_in                     : INTEGER := 0;
  SIGNAL s_axis_data_tvalid_i           : STD_LOGIC := '0';
  SIGNAL s_axis_data_tvalid_ii          : STD_LOGIC := '0';

  TYPE t_fir_response IS ARRAY (0 TO 999) OF INTEGER;
  CONSTANT C_FIR_RESPONSE               : t_fir_response := (
0,
0,
-1,
-1,
-1,
0,
0,
0,
0,
1,
1,
2,
3,
4,
4,
5,
7,
8,
9,
11,
13,
14,
16,
19,
21,
23,
25,
28,
30,
32,
35,
38,
41,
43,
46,
48,
51,
53,
55,
58,
60,
63,
65,
67,
68,
70,
72,
74,
75,
76,
77,
78,
79,
80,
81,
82,
82,
82,
83,
84,
84,
84,
84,
84,
85,
85,
85,
85,
85,
84,
84,
83,
82,
81,
79,
79,
77,
75,
74,
71,
68,
66,
63,
61,
57,
53,
50,
46,
43,
38,
34,
30,
26,
22,
17,
13,
10,
5,
1,
-3,
-7,
-10,
-14,
-18,
-21,
-24,
-26,
-29,
-31,
-34,
-36,
-38,
-40,
-41,
-41,
-43,
-44,
-46,
-46,
-46,
-48,
-48,
-48,
-48,
-49,
-49,
-49,
-50,
-52,
-50,
-49,
-49,
-48,
-48,
-47,
-47,
-46,
-44,
-43,
-41,
-40,
-38,
-34,
-33,
-30,
-27,
-24,
-19,
-16,
-12,
-8,
-4,
1,
5,
10,
15,
19,
23,
28,
33,
38,
42,
47,
50,
54,
58,
61,
65,
68,
70,
73,
74,
76,
79,
80,
82,
82,
83,
84,
84,
85,
85,
84,
85,
84,
85,
84,
83,
82,
83,
82,
83,
81,
81,
80,
78,
78,
77,
76,
74,
73,
71,
69,
67,
66,
63,
60,
57,
54,
51,
48,
45,
41,
37,
34,
29,
25,
20,
16,
13,
8,
5,
1,
-3,
-7,
-11,
-14,
-17,
-21,
-23,
-27,
-29,
-31,
-34,
-35,
-38,
-39,
-41,
-43,
-43,
-44,
-46,
-46,
-47,
-48,
-49,
-49,
-50,
-50,
-51,
-50,
-51,
-52,
-52,
-52,
-53,
-52,
-52,
-51,
-51,
-50,
-50,
-47,
-46,
-45,
-43,
-41,
-38,
-36,
-33,
-30,
-26,
-22,
-19,
-15,
-10,
-6,
-2,
3,
7,
12,
16,
20,
25,
29,
33,
38,
41,
45,
49,
52,
56,
58,
61,
64,
66,
69,
70,
73,
75,
75,
76,
78,
80,
80,
80,
82,
81,
82,
83,
83,
82,
82,
82,
83,
82,
81,
81,
80,
80,
78,
77,
75,
74,
72,
69,
68,
64,
62,
59,
56,
53,
48,
44,
40,
37,
32,
28,
22,
18,
13,
8,
3,
-2,
-6,
-11,
-16,
-20,
-24,
-28,
-33,
-37,
-40,
-43,
-46,
-49,
-52,
-53,
-55,
-57,
-60,
-61,
-61,
-62,
-63,
-63,
-64,
-65,
-64,
-64,
-66,
-64,
-65,
-63,
-63,
-63,
-62,
-63,
-62,
-61,
-61,
-60,
-59,
-58,
-57,
-56,
-55,
-53,
-51,
-49,
-47,
-45,
-42,
-40,
-36,
-33,
-30,
-26,
-22,
-18,
-14,
-9,
-4,
1,
6,
11,
15,
21,
26,
31,
36,
40,
45,
50,
54,
58,
62,
65,
69,
72,
75,
77,
80,
81,
83,
85,
86,
87,
88,
88,
89,
88,
89,
89,
89,
90,
89,
88,
88,
88,
89,
88,
87,
88,
86,
85,
85,
83,
83,
81,
80,
78,
76,
74,
71,
69,
66,
63,
59,
55,
52,
48,
43,
40,
35,
29,
25,
20,
15,
10,
5,
0,
-5,
-9,
-14,
-19,
-23,
-27,
-30,
-34,
-38,
-40,
-42,
-46,
-48,
-50,
-51,
-52,
-54,
-54,
-56,
-56,
-56,
-57,
-57,
-56,
-56,
-56,
-55,
-54,
-54,
-54,
-54,
-54,
-53,
-53,
-52,
-51,
-51,
-49,
-48,
-48,
-45,
-44,
-42,
-39,
-38,
-35,
-32,
-29,
-26,
-23,
-19,
-14,
-11,
-7,
-3,
2,
6,
10,
15,
19,
24,
29,
32,
36,
41,
45,
49,
51,
54,
58,
61,
63,
65,
67,
69,
70,
71,
72,
73,
74,
74,
75,
75,
75,
74,
74,
74,
75,
74,
72,
72,
72,
73,
72,
72,
71,
71,
70,
69,
68,
68,
67,
66,
63,
63,
61,
59,
56,
54,
50,
48,
45,
42,
38,
34,
31,
26,
22,
18,
14,
9,
4,
0,
-3,
-9,
-12,
-18,
-21,
-25,
-29,
-32,
-36,
-39,
-41,
-45,
-48,
-50,
-53,
-54,
-56,
-58,
-60,
-60,
-63,
-63,
-64,
-65,
-66,
-67,
-68,
-69,
-67,
-68,
-68,
-69,
-69,
-70,
-70,
-69,
-68,
-68,
-68,
-68,
-66,
-66,
-65,
-63,
-62,
-60,
-58,
-55,
-53,
-50,
-47,
-44,
-40,
-38,
-34,
-30,
-25,
-22,
-18,
-13,
-10,
-4,
0,
4,
9,
12,
17,
21,
25,
29,
33,
37,
40,
43,
46,
49,
52,
54,
57,
58,
60,
62,
65,
65,
66,
67,
68,
70,
70,
71,
72,
72,
72,
71,
73,
73,
73,
72,
72,
72,
72,
70,
70,
68,
67,
66,
65,
63,
61,
59,
56,
54,
51,
48,
44,
41,
37,
34,
29,
25,
21,
16,
12,
8,
3,
-2,
-6,
-10,
-15,
-19,
-23,
-27,
-31,
-34,
-39,
-42,
-44,
-47,
-50,
-53,
-56,
-56,
-59,
-60,
-63,
-63,
-64,
-66,
-66,
-66,
-67,
-67,
-69,
-68,
-68,
-68,
-68,
-69,
-68,
-67,
-67,
-66,
-66,
-66,
-64,
-62,
-61,
-60,
-58,
-56,
-54,
-51,
-47,
-45,
-42,
-39,
-35,
-31,
-27,
-22,
-19,
-14,
-9,
-4,
0,
6,
10,
15,
21,
25,
30,
35,
39,
43,
47,
52,
56,
59,
62,
65,
68,
71,
73,
75,
76,
78,
79,
80,
82,
82,
83,
83,
83,
83,
83,
84,
82,
82,
81,
82,
81,
80,
79,
78,
78,
77,
75,
73,
71,
70,
68,
66,
64,
61,
59,
55,
52,
50,
45,
43,
38,
35,
31,
26,
22,
17,
13,
9,
5,
-1,
-5,
-9,
-14,
-18,
-22,
-26,
-30,
-34,
-37,
-40,
-42,
-46,
-48,
-51,
-53,
-55,
-57,
-58,
-60,
-62,
-62,
-63,
-63,
-64,
-65,
-65,
-65,
-65,
-65,
-64,
-64,
-64,
-65,
-64,
-63,
-63,
-63,
-62,
-61,
-60,
-59,
-58,
-57,
-55,
-53,
-51,
-49,
-47,
-45,
-42,
-39,
-37,
-34,
-30,
-27,
-24,
-21,
-17,
-14,
-10,
-6,
-3,
1,
4,
9,
12,
15,
19,
23,
26,
29,
32,
34,
37,
40,
43,
45,
47,
49,
51,
53,
54,
57,
57,
59,
61,
62,
62,
64,
65,
66,
65,
67,
67,
69,
69,
70,
70,
70,
71,
70,
69,
69,
68,
68,
67,
65,
63,
61,
60,
57,
54,
52,
49,
45,
42,
38,
35,
31,
27,
22,
17,
13,
9,
5,
0,
-4,
-8,
-12,
-16,
-20,
-23,
-28,
-31,
-34,
-36,
-39,
-42,
-43,
-46,
-48,
-48,
-51,
-52,
-52,
-53,
-54,
-54,
-54,
-54,
-55,
-54,
-55,
-53,
-53
  );


  CONSTANT C_FIR_IN : t_fir_response := (
127,
128,
127,
127,
193,
127,
143,
131,
131,
160,
136,
127,
127,
209,
127,
147,
163,
132,
160,
200,
193,
143,
65,
127,
144,
131,
131,
226,
136,
143,
131,
213,
160,
156,
163,
132,
242,
200,
213,
179,
70,
160,
215,
197,
147,
32,
136,
128,
127,
209,
193,
147,
179,
128,
164,
231,
202,
143,
65,
209,
144,
143,
-96,
-26,
-88,
-39,
-58,
-58,
-157,
-99,
-75,
-127,
-9,
-86,
-33,
-92,
-189,
-9,
-7,
-37,
-80,
-220,
-6,
-56,
-42,
-26,
-251,
-75,
-20,
-57,
-79,
-183,
-62,
-111,
-190,
-128,
-45,
-124,
-108,
-25,
-115,
-79,
-115,
-42,
-95,
-49,
-92,
-111,
-41,
-52,
-9,
-3,
-251,
-79,
-230,
-58,
-123,
-219,
-115,
-30,
-119,
-62,
-58,
-62,
-107,
155,
128,
236,
183,
216,
19,
229,
85,
176,
247,
159,
187,
119,
206,
198,
98,
206,
246,
148,
194,
170,
249,
203,
7,
230,
58,
136,
160,
51,
217,
173,
253,
190,
66,
242,
14,
217,
131,
71,
180,
186,
28,
163,
15,
242,
236,
187,
188,
20,
246,
157,
246,
168,
32,
163,
186,
138,
197,
51,
70,
159,
215,
-58,
-42,
-223,
-103,
-123,
-124,
-13,
-53,
-108,
-76,
-45,
-91,
-4,
-17,
-107,
-157,
-101,
-45,
-128,
-158,
-26,
-71,
-35,
-62,
-91,
-150,
-115,
-79,
-41,
-42,
-73,
-5,
-95,
-208,
-66,
-81,
-17,
-137,
-251,
-94,
-114,
-62,
-185,
-244,
-76,
-20,
-107,
-13,
-163,
-10,
-112,
-153,
-24,
-104,
-108,
-170,
-75,
-100,
-95,
-83,
-80,
-119,
-106,
225,
214,
51,
208,
193,
251,
113,
154,
68,
225,
69,
81,
243,
184,
184,
101,
187,
137,
194,
249,
3,
215,
211,
157,
36,
46,
19,
159,
57,
159,
238,
123,
218,
159,
109,
253,
249,
194,
225,
227,
221,
220,
94,
170,
75,
243,
35,
4,
63,
231,
250,
25,
77,
144,
5,
151,
193,
9,
159,
166,
27,
200,
-216,
-86,
-135,
-38,
-149,
-220,
-113,
-66,
-53,
-175,
-146,
-29,
-168,
-60,
-79,
-223,
-252,
-117,
-94,
-118,
-162,
-186,
-222,
-116,
-91,
-185,
-111,
-70,
-54,
-20,
-154,
-113,
-160,
-49,
-153,
-173,
-26,
-69,
-1,
-62,
-215,
-82,
-81,
-103,
-169,
-232,
-58,
-55,
-95,
-98,
-166,
-123,
-245,
-75,
-23,
-165,
-80,
-219,
-6,
-56,
-108,
-26,
-235,
176,
231,
229,
183,
72,
193,
194,
65,
147,
246,
128,
180,
173,
206,
160,
78,
213,
175,
202,
159,
241,
221,
219,
242,
170,
35,
171,
61,
194,
245,
107,
218,
213,
77,
226,
157,
131,
128,
60,
135,
235,
183,
138,
85,
241,
97,
175,
220,
199,
246,
103,
12,
148,
113,
222,
214,
242,
234,
241,
187,
137,
234,
-6,
-242,
-120,
-42,
-226,
-123,
-118,
-195,
-56,
-198,
-88,
-193,
-130,
-2,
-256,
-29,
-35,
-104,
-111,
-132,
-76,
-36,
-139,
-1,
-252,
-203,
-98,
-92,
-83,
-203,
-61,
-74,
-70,
-53,
-158,
-154,
-17,
-4,
-41,
-127,
-147,
-18,
-8,
-255,
-62,
-175,
-46,
-79,
-138,
-88,
-98,
-26,
-41,
-219,
-39,
-58,
-100,
-157,
-117,
-127,
-124,
-170,
-61,
187,
187,
200,
246,
233,
78,
179,
229,
210,
240,
215,
249,
51,
45,
215,
193,
73,
31,
182,
188,
204,
32,
168,
114,
135,
174,
163,
154,
22,
205,
81,
124,
168,
153,
47,
147,
24,
228,
142,
234,
8,
67,
180,
225,
4,
177,
227,
197,
124,
88,
177,
12,
125,
69,
227,
203,
148,
90,
28,
220,
207,
236,
-146,
-197,
-224,
-13,
-225,
-36,
-128,
-151,
-200,
-69,
-195,
-2,
-232,
-91,
-37,
-71,
-100,
-8,
-75,
-90,
-131,
-93,
-142,
-206,
-197,
-55,
-181,
-220,
-159,
-2,
-15,
-227,
-32,
-252,
-30,
-160,
-112,
-3,
-188,
-65,
-246,
-249,
-227,
-204,
-152,
-42,
-45,
-187,
-72,
-42,
-188,
-27,
-100,
-239,
-243,
-99,
-64,
-35,
-22,
-233,
-160,
-16,
-169,
91,
83,
215,
11,
61,
17,
181,
88,
40,
90,
88,
164,
192,
122,
153,
124,
175,
9,
53,
194,
55,
123,
232,
205,
97,
0,
164,
228,
202,
146,
23,
209,
64,
163,
148,
74,
204,
216,
196,
75,
98,
119,
32,
184,
88,
139,
132,
112,
152,
246,
35,
238,
133,
210,
158,
23,
224,
88,
167,
52,
119,
251,
-107,
-145,
-131,
-48,
-96,
-210,
-216,
-22,
-137,
-54,
-24,
-68,
-114,
-161,
-5,
-214,
-32,
-99,
-180,
-185,
-56,
-216,
-36,
-197,
-57,
-233,
-217,
-22,
-186,
-236,
-28,
-88,
-79,
-190,
-36,
-109,
-109,
-196,
-158,
-184,
-63,
-9,
-256,
-161,
-113,
-74,
-3,
-173,
-141,
-241,
-37,
-124,
-184,
-9,
-69,
-243,
-96,
-236,
-46,
-28,
-68,
-67,
-185,
246,
137,
210,
171,
-1,
236,
248,
154,
3,
51,
85,
163,
219,
164,
222,
48,
156,
210,
164,
237,
238,
144,
198,
153,
242,
199,
39,
179,
58,
220,
198,
32,
106,
230,
184,
142,
127,
176,
93,
139,
147,
190,
156,
166,
56,
242,
32,
173,
142,
136,
94,
91,
227,
199,
32,
89,
56,
180,
154,
190,
171,
120,
-203,
-25,
-226,
-77,
-88,
-208,
-212,
-3,
-54,
-57,
-216,
-123,
-27,
-47,
-45,
-226,
-138,
-64,
-256,
-4,
-223,
-97,
-175,
-123,
-181,
-157,
-7,
-17,
-104,
-215,
-104,
-101,
-108,
-74,
-141,
-91,
-175,
-81,
-65,
-151,
-239,
-251,
-201,
-62,
-26,
-194,
-99,
-30,
-133,
-30,
-5,
-82,
-38,
-67,
-182,
-69,
-119,
-102,
-204,
-44,
-232,
-3,
-241,
174,
23,
84,
56,
131,
68,
178,
183,
69,
39,
191,
166,
191,
8,
29,
34,
243,
20,
26,
75,
204,
67,
10,
105,
42,
108,
254,
43,
4,
147,
247,
206,
181,
98,
210,
84,
145,
209,
109,
47,
157,
240,
230,
31,
58,
166,
238,
62,
20,
175,
25,
229,
198,
44,
220,
227,
140,
98,
74,
226,
180,
205,
-117,
-71,
-98,
-168,
-75,
-245,
-195,
-119,
-136,
-72,
-19,
-130,
-21,
-220,
-26,
-66,
-47,
-61,
-152,
-142,
-3,
-147,
-5,
-256,
-252,
-105,
-96,
-115,
-154,
-61,
-30,
-36,
-34,
-45,
-209,
-88,
-52,
-236,
-61,
-196,
-72,
-24,
-10,
-22,
-179,
-10,
-26,
-185,
-11,
-4,
-45,
-203,
-148,
-54,
-112,
-182,
-112,
-109,
-112,
-92,
-158,
-87,
-15
);

----------------------------------------------------------------------------------
BEGIN
----------------------------------------------------------------------------------

  PROCESS(aclk) BEGIN
    IF rising_edge(aclk) THEN
      IF s_axis_data_tvalid = '1' THEN
        IF NOT (STD_LOGIC_VECTOR(TO_SIGNED(C_FIR_IN(cnt_fir_in),s_axis_data_tdata'LENGTH)) = s_axis_data_tdata) THEN
          REPORT LF & "----------------------------------------------------------------------------------" & LF &
                 "ERROR: Mismatch of input data! Expected data " &
                 INTEGER'image(C_FIR_IN(cnt_fir_in)) &
                 ", actual data " &
                 INTEGER'image(TO_INTEGER(SIGNED(s_axis_data_tdata))) &
                 LF & "----------------------------------------------------------------------------------" & LF
          SEVERITY ERROR;
        END IF;
        cnt_fir_in <= cnt_fir_in + 1;
      END IF;
    END IF;
  END PROCESS;


  --------------------------------------------------------------------------------

  PROCESS(aclk) BEGIN
    IF rising_edge(aclk) THEN
      s_axis_data_tvalid_i  <= s_axis_data_tvalid;
      s_axis_data_tvalid_ii <= s_axis_data_tvalid_i;
      m_axis_data_tvalid    <= s_axis_data_tvalid_ii;

      IF s_axis_data_tvalid_ii = '1' THEN

        IF cnt_fir_out = 999 THEN
          cnt_fir_out <= 0;
        ELSE
          cnt_fir_out <= cnt_fir_out + 1;
        END IF;

        m_axis_data_tdata <= STD_LOGIC_VECTOR(TO_SIGNED(C_FIR_RESPONSE(cnt_fir_out),m_axis_data_tdata'LENGTH));

      END IF;


    END IF;
  END PROCESS;

  s_axis_data_tready <= '1';

----------------------------------------------------------------------------------
END structural;
----------------------------------------------------------------------------------
