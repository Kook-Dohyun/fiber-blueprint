package authority

import (
	"errors"
	"strconv"
	"strings"
)

// (A) 10가지 decodeMethodN

// 1) decodeMethod1: 짝수 인덱스 -> A
func decodeMethod1(mixed string) (string, error) {
	// mixed.length = 2 * len(A)
	if len(mixed)%2 != 0 {
		return "", errors.New("method1: invalid length")
	}
	var sb strings.Builder
	// 짝수 인덱스 모으기
	for i := 0; i < len(mixed); i += 2 {
		sb.WriteByte(mixed[i])
	}
	return sb.String(), nil
}

// 2) decodeMethod2: 홀수 인덱스 -> A
func decodeMethod2(mixed string) (string, error) {
	if len(mixed)%2 != 0 {
		return "", errors.New("method2: invalid length")
	}
	var sb strings.Builder
	for i := 1; i < len(mixed); i += 2 {
		sb.WriteByte(mixed[i])
	}
	return sb.String(), nil
}

// 3) decodeMethod3: 2글자씩 reverse => A는 앞 절반
// encode는 (B[i], A[i]) 로 2글자씩 => ex: [B0,A0, B1,A1 ...]
// 여기선 decoding:
//   - chunk(2): [B0,A0] -> reverse= [A0,B0] => 한 덩어리
//   - 모두 이어붙이면 => A0B0A1B1...
//   - 앞 len(A) 개 => A
func decodeMethod3(mixed string) (string, error) {
	if len(mixed)%2 != 0 {
		return "", errors.New("method3: length not even")
	}
	runes := []rune(mixed)
	var temp []rune

	// 1) 2글자씩 꺼내서 reverse
	//    chunk = [B[i], A[i]]
	//    reverse => [A[i], B[i]]
	//    => temp = "A0 B0 A1 B1 A2 B2 ..."
	for i := 0; i < len(runes); i += 2 {
		temp = append(temp, runes[i+1]) // A
		temp = append(temp, runes[i])   // B
	}

	// 2) temp: 길이 2N, 인덱스 (0,2,4,...) => A
	var sb strings.Builder
	for i := 0; i < len(temp); i += 2 {
		sb.WriteRune(temp[i]) // even 인덱스가 A
	}

	return sb.String(), nil // 최종적으로 A
}

// 4) decodeMethod4: encode= reversed(A) + B
// => decode: A 길이= ?
func decodeMethod4(mixed string) (string, error) {
	// mixed= reversed(A) + B
	// A, B 길이는 같다고 가정.
	// => len(mixed)= 2*len(A)
	l := len(mixed)
	if l%2 != 0 {
		return "", errors.New("method4: invalid length")
	}
	half := l / 2
	revA := mixed[:half] // reversed A
	// bPart := mixed[half:] // B

	// 이제 revA를 다시 뒤집으면 A가 됨
	runes := []rune(revA)
	for i, j := 0, len(runes)-1; i < j; i, j = i+1, j-1 {
		runes[i], runes[j] = runes[j], runes[i]
	}
	A := string(runes) // 원래 A

	// bPart는 쓰레기 B, ignore
	return A, nil
}

// 5) decodeMethod5: 대문자(A) + 소문자(B)
func decodeMethod5(mixed string) (string, error) {
	var sb strings.Builder
	for _, r := range mixed {
		// 'A'..'Z' or '0'..'9' or ...
		if (r >= 'A' && r <= 'Z') || (r >= '0' && r <= '9') {
			sb.WriteRune(r)
		}
	}
	// 만약 특수문자도 Pepper에 포함된다면, 그 부분도 고려
	A := sb.String()
	if len(A) == 0 {
		return "", errors.New("method5: no uppercase or digits found => invalid")
	}
	// toLower
	return strings.ToLower(A), nil
}

// 6) decodeMethod6: A+B (직접 결합)
// => decode: 앞 len(A) 문자가 A
func decodeMethod6(mixed string) (string, error) {
	if len(mixed) < 2 {
		return "", errors.New("method6: too short")
	}
	// 절반이 A, 절반이 B
	l := len(mixed)
	if l%2 != 0 {
		return "", errors.New("method6: length not even")
	}
	half := l / 2
	A := mixed[:half] // 앞 절반
	return A, nil
}

// 7) decodeMethod7: B + A
// => decode: skip first len(B) => A
func decodeMethod7(mixed string) (string, error) {
	if len(mixed)%2 != 0 {
		return "", errors.New("method7: length not even")
	}
	half := len(mixed) / 2
	A := mixed[half:]
	return A, nil
}

// 8) decodeMethod8: (A+B) reversed
// => decode: 다시 reverse => (A+B), 그중 앞 len(A)= A
func decodeMethod8(mixed string) (string, error) {
	runes := []rune(mixed)
	// reverse
	for i, j := 0, len(runes)-1; i < j; i, j = i+1, j-1 {
		runes[i], runes[j] = runes[j], runes[i]
	}
	combined := string(runes) // => "A+B"
	if len(combined)%2 != 0 {
		return "", errors.New("method8: length not even")
	}
	half := len(combined) / 2
	return combined[:half], nil
}

// 9) decodeMethod9: "A#B"
// => decode: '#' 찾아서 앞부분= A
func decodeMethod9(mixed string) (string, error) {
	parts := strings.Split(mixed, "#")
	if len(parts) != 2 {
		return "", errors.New("method9: invalid format, must have one '#'")
	}
	return parts[0], nil
}

// -------------------------------------

var decodeFns = []func(string) (string, error){
	decodeMethod1,
	decodeMethod2,
	decodeMethod3,
	decodeMethod4,
	decodeMethod5,
	decodeMethod6,
	decodeMethod7,
	decodeMethod8,
	decodeMethod9,
}

func DecodeWithMethod(methodNum int, mixed string) (string, error) {
	if methodNum < 1 || methodNum > 10 {
		return "", errors.New("invalid method number")
	}
	return decodeFns[methodNum-1](mixed)
}

// ParseObfValue: 끝 1글자 -> method
func ParseObfValue(singleValue string) (string, int, error) {
	if len(singleValue) < 2 {
		return "", 0, errors.New("too short")
	}
	lastChar := singleValue[len(singleValue)-1:]
	m, e := strconv.Atoi(lastChar)
	if e != nil {
		return "", 0, errors.New("invalid method digit")
	}
	rest := singleValue[:len(singleValue)-1]
	return rest, m, nil
}
