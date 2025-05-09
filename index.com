<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>일주 계산</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            text-align: center;
        }
        table {
            width: 50%;
            margin: 20px auto;
            border-collapse: collapse;
        }
        th, td {
            border: 1px solid black;
            padding: 10px;
            text-align: center;
        }
        th {
            background-color: #f2f2f2;
        }
    </style>
    <script>
        function calculateDayStemBranch() {
            let birthDateInput = document.getElementById("birthDate").value;
            if (!/^\d{8}$/.test(birthDateInput)) {
                alert("생년월일을 YYYYMMDD 형식으로 입력하세요.");
                return;
            }

            let birthYear = parseInt(birthDateInput.substring(0, 4));
            let birthMonth = parseInt(birthDateInput.substring(4, 6));
            let birthDay = parseInt(birthDateInput.substring(6, 8));

            let dayStemBranch = getAccurateDayStemBranch(birthYear, birthMonth, birthDay);

            document.getElementById("dayStemBranchCell").innerText = dayStemBranch;
        }

        function getAccurateDayStemBranch(year, month, day) {
            const heavenlyStems = ["갑", "을", "병", "정", "무", "기", "경", "신", "임", "계"];
            const earthlyBranches = ["자", "축", "인", "묘", "진", "사", "오", "미", "신", "유", "술", "해"];

            // 1984년 2월 4일(입춘) 기준으로 날짜 계산
            let baseDate = new Date(1984, 1, 4); // 1984년 2월 4일
            let inputDate = new Date(year, month - 1, day);
            let dayDifference = Math.floor((inputDate - baseDate) / (1000 * 60 * 60 * 24));

            let dayStem = heavenlyStems[(dayDifference % 10 + 10) % 10];
            let dayBranch = earthlyBranches[(dayDifference % 12 + 12) % 12];

            return dayStem + dayBranch;
        }
    </script>
</head>
<body>
    <h2>일주 계산</h2>
    <label for="birthDate">생년월일 입력 (YYYYMMDD 형식):</label>
    <input type="text" id="birthDate" maxlength="8" placeholder="예: 20250101">
    <button onclick="calculateDayStemBranch()">결과 확인</button>

    <h3>결과:</h3>
    <table>
        <tr>
            <th>일주 (일간 + 일지)</th>
        </tr>
        <tr>
            <td id="dayStemBranchCell"></td>
        </tr>
    </table>
</body>
</html>
