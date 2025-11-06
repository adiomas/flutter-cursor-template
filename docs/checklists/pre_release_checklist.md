# Pre-Release Checklist

Complete this checklist before releasing to production.

## Code Quality

- [ ] All linter warnings resolved
- [ ] Code formatted
- [ ] No debug code left
- [ ] No console.log statements
- [ ] All TODOs resolved or documented
- [ ] Code coverage >= 80%
- [ ] All tests passing

## Features

- [ ] All planned features implemented
- [ ] All features tested manually
- [ ] All features tested on multiple devices
- [ ] Edge cases handled
- [ ] Error scenarios tested
- [ ] Performance tested

## UI/UX

- [ ] UI matches approved designs
- [ ] All screens implemented
- [ ] Loading states implemented
- [ ] Empty states implemented
- [ ] Error states implemented
- [ ] Animations smooth (60 FPS)
- [ ] Touch targets adequate
- [ ] Responsive on all screen sizes
- [ ] Works in landscape mode
- [ ] Dark mode tested

## Accessibility

- [ ] All images have semantic labels
- [ ] Color contrast WCAG AA compliant
- [ ] Touch targets >= 44x44pt
- [ ] Screen reader tested
- [ ] Keyboard navigation works
- [ ] Text scales properly

## Performance

- [ ] App starts in < 2 seconds
- [ ] No jank in animations
- [ ] Memory usage acceptable
- [ ] No memory leaks
- [ ] Network calls optimized
- [ ] Images optimized
- [ ] Bundle size acceptable

## Security

- [ ] API keys not exposed
- [ ] Sensitive data encrypted
- [ ] SSL/TLS properly configured
- [ ] User data protected
- [ ] Input validation implemented
- [ ] Authentication secure
- [ ] Authorization implemented

## Platform Specific

### iOS
- [ ] Builds without warnings
- [ ] App icon set (all sizes)
- [ ] Launch screen configured
- [ ] Permissions properly described
- [ ] Deep links configured
- [ ] Push notifications configured
- [ ] Tested on iPhone and iPad
- [ ] Tested on latest iOS version

### Android
- [ ] Builds without warnings
- [ ] App icon set (all sizes)
- [ ] Splash screen configured
- [ ] Permissions properly requested
- [ ] Deep links configured
- [ ] Push notifications configured
- [ ] Tested on multiple devices
- [ ] Tested on latest Android version

## Backend/API

- [ ] API endpoints documented
- [ ] Rate limiting configured
- [ ] Error responses documented
- [ ] Database migrations applied
- [ ] RLS policies configured
- [ ] Indexes created
- [ ] Backup strategy in place

## Monitoring

- [ ] Analytics integrated
- [ ] Crash reporting configured
- [ ] Performance monitoring setup
- [ ] Error tracking configured
- [ ] Alerts configured

## Documentation

- [ ] README updated
- [ ] CHANGELOG updated
- [ ] API documentation updated
- [ ] User documentation updated
- [ ] Release notes prepared
- [ ] Migration guide written (if needed)

## Legal

- [ ] Privacy policy updated
- [ ] Terms of service updated
- [ ] Third-party licenses included
- [ ] GDPR compliance checked
- [ ] App Store guidelines reviewed
- [ ] Play Store guidelines reviewed

## Store Listings

### App Store
- [ ] App name finalized
- [ ] Description written
- [ ] Keywords optimized
- [ ] Screenshots captured (all sizes)
- [ ] App preview video (optional)
- [ ] App icon uploaded
- [ ] Privacy policy URL set
- [ ] Support URL set
- [ ] Age rating set
- [ ] Build uploaded to TestFlight
- [ ] Beta testing completed

### Play Store
- [ ] App name finalized
- [ ] Short description written
- [ ] Full description written
- [ ] Screenshots captured
- [ ] Feature graphic created
- [ ] App icon uploaded
- [ ] Privacy policy URL set
- [ ] Content rating completed
- [ ] Pricing set
- [ ] Distribution countries selected
- [ ] AAB uploaded
- [ ] Internal testing completed

## Final Checks

- [ ] Version number incremented
- [ ] Build number incremented
- [ ] Release branch created
- [ ] Tag created
- [ ] CI/CD pipeline successful
- [ ] Staging deployment tested
- [ ] Production deployment planned
- [ ] Rollback plan prepared
- [ ] Team notified
- [ ] Support team briefed

## Post-Release

- [ ] Monitor crash reports
- [ ] Monitor error logs
- [ ] Check analytics
- [ ] Monitor user reviews
- [ ] Respond to user feedback
- [ ] Plan hotfix if needed

---

**Release Manager:** _______________  
**Date:** _______________  
**Version:** _______________

