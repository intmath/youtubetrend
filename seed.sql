-- [1] 샘플 채널 정보 삽입
INSERT INTO Channels (id, title, country, category, thumbnail) VALUES 
('UC-lHJZR3Gqxm24_Vd_AJ5Yw', 'PewDiePie', 'GB', '20', 'https://pub-static.fancode.com/600x600/1.png'),
('UC0C-w0YjGpqDXGB8Tr0G4Pw', 'Felipe Neto', 'BR', '24', 'https://pub-static.fancode.com/600x600/2.png'),
('UC4909Uv_tSdfp_XG6_mI67g', '이세상모든쇼츠', 'KR', '24', 'https://pub-static.fancode.com/600x600/3.png');

-- [2] 어제 날짜 통계 데이터 (성장률 계산용)
INSERT INTO ChannelStats (channel_id, subs, views, rank_date) VALUES 
('UC-lHJZR3Gqxm24_Vd_AJ5Yw', 111000000, 29000000000, DATE(CURRENT_DATE, '-1 day')),
('UC0C-w0YjGpqDXGB8Tr0G4Pw', 46000000, 16000000000, DATE(CURRENT_DATE, '-1 day')),
('UC4909Uv_tSdfp_XG6_mI67g', 100000, 50000000, DATE(CURRENT_DATE, '-1 day'));

-- [3] 오늘 날짜 통계 데이터 (현재 수치)
INSERT INTO ChannelStats (channel_id, subs, views, rank_date) VALUES 
('UC-lHJZR3Gqxm24_Vd_AJ5Yw', 111050000, 29010000000, CURRENT_DATE),
('UC0C-w0YjGpqDXGB8Tr0G4Pw', 46080000, 16020000000, CURRENT_DATE),
('UC4909Uv_tSdfp_XG6_mI67g', 105000, 52000000, CURRENT_DATE);