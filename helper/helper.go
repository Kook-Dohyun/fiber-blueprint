package helper

import "github.com/lib/pq"

func StrPtr(s string) *string {
	if s == "" {
		return nil
	}
	return &s
}
func StringArrayPtr(arr pq.StringArray) *pq.StringArray {
	if len(arr) == 0 {
		return nil
	}
	return &arr
}
